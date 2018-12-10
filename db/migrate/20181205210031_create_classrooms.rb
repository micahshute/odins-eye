class CreateClassrooms < ActiveRecord::Migration[5.2]
  def change
    create_table :classrooms do |t|
      t.string :name
      t.integer :user_id
      t.boolean :private, default: true
      t.timestamps
    end
  end
end
