class CreateCourseTable < ActiveRecord::Migration[6.0]
  def change
    create_table :courses do |t|
      t.string :title
      t.string :duration
      t.references :school
      t.references :user

      t.timestamps
    end
  end
end
