class CreateUserReactions < ActiveRecord::Migration[5.2]
  def change
    create_table :user_reactions do |t|
      t.integer :user_id
      t.references :reactable, polymorphic: true, index: true
      t.integer :reaction_id
      t.timestamps
    end
  end
end
