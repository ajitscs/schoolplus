class AddStatusToStudentBatch < ActiveRecord::Migration[6.0]
  def change
    add_column :student_batches, :status, :integer, default: 0
  end
end
