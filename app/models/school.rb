class School < ApplicationRecord
  validates :title, :address, :contact, presence: true
  validates_format_of :contact, :with =>  /\d[0-9]\)*\z/ , :message => "Only positive number without spaces are allowed"

  has_many :school_admins, class_name: "User", foreign_key: :school_id
  has_many :students, class_name: "User", foreign_key: :school_id 
end
