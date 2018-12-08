class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :google_uid
      t.string :google_refresh_token
      t.string :password_digest
      t.text :bio
      t.boolean :admin, default: false

      t.timestamps
    end
  end
end
