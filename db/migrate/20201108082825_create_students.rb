class CreateStudents < ActiveRecord::Migration[5.2]
  def change
    create_table :students do |t|
      t.string :student_class
      t.string :student_name,null: false
      t.string :parent_name
      t.string :line_id
      t.boolean :enabled

      t.timestamps
    end
  end
end
