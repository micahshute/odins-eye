class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.integer :user_id
      t.string :content
      t.boolean :is_private
      t.references :postable, polymorphic: true, index: true

      t.timestamps
    end
  end
end
