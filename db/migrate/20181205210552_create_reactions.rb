class CreateReactions < ActiveRecord::Migration[5.2]
  def change
    create_table :reactions do |t|
      t.integer :user_id
      t.references :reactable, polymorphic: true, index: true
      t.integer :reaction_type_id
      t.timestamps
    end
  end
end
