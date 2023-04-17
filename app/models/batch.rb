class Batch < ApplicationRecord
  validates :title, :start_date, presence: true
  
  belongs_to :school
  belongs_to :user 
  belongs_to :course
end
