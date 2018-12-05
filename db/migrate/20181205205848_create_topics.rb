class CreateTopics < ActiveRecord::Migration[5.2]
  def change
    create_table :topics do |t|
      t.integer :user_id
      t.text :content
      t.integer :views

      t.timestamps
    end
  end
end
