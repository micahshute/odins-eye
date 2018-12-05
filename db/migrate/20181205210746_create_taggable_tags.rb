class CreateTaggableTags < ActiveRecord::Migration[5.2]
  def change
    create_table :taggable_tags do |t|
      t.string :tag_id
      t.references :taggable, polymorphic: true, index: true

      t.timestamps
    end
  end
end
