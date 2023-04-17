class CreateBatch < ActiveRecord::Migration[6.0]
  def change
    create_table :batches do |t|
      t.string :title
      t.string :start_date
      t.references :school
      t.references :user
      t.references :course

      t.timestamps
    end
  end
end
