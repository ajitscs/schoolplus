class CreateStudentBatch < ActiveRecord::Migration[6.0]
  def change
    create_table :student_batches do |t|
      t.references :user, index: true
      t.references :batch, index: true
    end
  end
end
