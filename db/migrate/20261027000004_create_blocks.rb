class CreateBlocks < ActiveRecord::Migration[8.1]
  def change
    create_table :blocks, primary_key: [ :blocker_id, :blocked_id ] do |t|
      t.references :blocker, type: :uuid, null: false, index: false, foreign_key: { to_table: :users, on_delete: :cascade }
      t.references :blocked, type: :uuid, null: false, foreign_key: { to_table: :users, on_delete: :cascade }
      t.datetime :created_at, null: false

      t.check_constraint "blocker_id <> blocked_id", name: "blocks_not_self_check"
    end
  end
end
