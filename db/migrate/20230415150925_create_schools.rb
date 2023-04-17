class CreateSchools < ActiveRecord::Migration[6.0]
  def change
    create_table :schools do |t|
      t.string :title
      t.string :address
      t.string :contact

      t.timestamps
    end
  end
end
