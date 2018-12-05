class CreateUerReactions < ActiveRecord::Migration[5.2]
  def change
    create_table :uer_reactions do |t|
      t.string :user_id
      t.references :reactable, polymorphic: true, index: true

      t.timestamps
    end
  end
end
