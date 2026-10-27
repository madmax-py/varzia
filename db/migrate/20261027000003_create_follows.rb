class CreateFollows < ActiveRecord::Migration[8.1]
  def change
    create_table :follows, primary_key: [ :follower_id, :followed_id ] do |t|
      t.references :follower, type: :uuid, null: false, index: false, foreign_key: { to_table: :users, on_delete: :cascade }
      t.references :followed, type: :uuid, null: false, foreign_key: { to_table: :users, on_delete: :cascade }
      t.datetime :created_at, null: false

      t.check_constraint "follower_id <> followed_id", name: "follows_not_self_check"
    end
  end
end
