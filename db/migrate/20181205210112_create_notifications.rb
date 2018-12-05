class CreateNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :notifications do |t|
      t.integer :user_id
      t.string :content
      t.boolean :viewed

      t.timestamps
    end
  end
end
