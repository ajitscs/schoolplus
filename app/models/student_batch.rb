class StudentBatch < ApplicationRecord
  validates :user_id, uniqueness: { scope: :batch_id }

  belongs_to :batch
  belongs_to :user

  enum status: { requested: 0, approved: 1, denied: 2 }
end
