class Course < ApplicationRecord
  validates :title, :duration, presence: true
  
  belongs_to :school
  belongs_to :user 
end
