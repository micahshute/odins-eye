class CreateUserSavedTopics < ActiveRecord::Migration[5.2]
  def change
    create_table :user_saved_topics do |t|
      t.integer :user_id
      t.integer :topic_id

      t.timestamps
    end
  end
end
