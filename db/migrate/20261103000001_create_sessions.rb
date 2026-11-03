class CreateSessions < ActiveRecord::Migration[8.1]
  def change
    # One row per logged-in device. Only a digest of the token is stored.
    create_table :sessions, id: :uuid, default: -> { "gen_random_uuid()" } do |t|
      t.references :user, type: :uuid, null: false, foreign_key: { on_delete: :cascade }
      t.string :token_digest, null: false
      t.string :user_agent
      t.string :ip_address
      t.datetime :last_used_at
      t.datetime :created_at, null: false

      t.index :token_digest, unique: true
    end
  end
end
