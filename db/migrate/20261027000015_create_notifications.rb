class CreateNotifications < ActiveRecord::Migration[8.1]
  def change
    create_table :notifications, id: :uuid, default: -> { "gen_random_uuid()" } do |t|
      t.references :user, type: :uuid, null: false, index: false, foreign_key: { on_delete: :cascade }
      t.references :actor, type: :uuid, null: false, foreign_key: { to_table: :users, on_delete: :cascade }
      t.string :kind, null: false
      t.references :target, type: :uuid, polymorphic: true, index: false
      t.datetime :read_at
      t.datetime :created_at, null: false

      t.index [ :user_id, :created_at ]
      t.index :user_id, where: "read_at IS NULL", name: "index_notifications_unread"
      # Groups "Fulano e mais 40 riram" by target.
      t.index [ :user_id, :kind, :target_type, :target_id ], name: "index_notifications_for_grouping"
      t.check_constraint "kind IN ('laugh', 'comment', 'follow')", name: "notifications_kind_check"
    end
  end
end
