class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :google_uid
      t.string :google_refresh_token
      t.string :password_digest
      t.string :image_path, default: "https://i.imgur.com/JkzJkzM.png"
      t.string :github_url
      t.string :facebook_url
      t.string :linkedin_url
      t.text :bio
      t.boolean :display_email, default: true
      t.boolean :admin, default: false

      t.timestamps
    end
  end
end
