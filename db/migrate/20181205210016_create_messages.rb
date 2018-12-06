class CreateMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :messages do |t|
      t.integer :sender_id
      t.integer :reciever_id
      t.text :content
      t.boolean :viewed, default: false

      t.timestamps
    end
  end
end
