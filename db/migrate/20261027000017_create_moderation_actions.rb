class CreateModerationActions < ActiveRecord::Migration[8.1]
  def change
    create_table :moderation_actions, id: :uuid, default: -> { "gen_random_uuid()" } do |t|
      t.references :moderator, type: :uuid, null: false, foreign_key: { to_table: :users }
      # Null means the moderator acted without a report.
      t.references :report, type: :uuid, foreign_key: true
      t.string :action, null: false
      t.references :target, type: :uuid, null: false, polymorphic: true
      t.text :reason
      # Null means permanent.
      t.datetime :expires_at
      t.datetime :created_at, null: false

      t.check_constraint "action IN ('remove', 'warn', 'suspend', 'ban')", name: "moderation_actions_action_check"
      t.check_constraint "target_type IN ('Meme', 'Comment', 'User')", name: "moderation_actions_target_type_check"
    end
  end
end
