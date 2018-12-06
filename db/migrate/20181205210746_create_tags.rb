class CreateTags < ActiveRecord::Migration[5.2]
  def change
    create_table :tags do |t|
      t.integer :tag_type_id
      t.references :taggable, polymorphic: true, index: true
      t.integer :user_id
      t.timestamps
    end
  end
end
