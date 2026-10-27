class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users, id: :uuid, default: -> { "gen_random_uuid()" } do |t|
      t.citext :username, null: false
      t.citext :email, null: false
      t.string :password_digest, null: false
      t.string :display_name
      t.string :avatar_url
      t.text :bio
      t.string :status, null: false, default: "active"
      t.timestamps

      t.index :username, unique: true
      t.index :email, unique: true
      t.check_constraint "status IN ('active', 'suspended', 'banned')", name: "users_status_check"
    end
  end
end
