class CreateCommunityMembers < ActiveRecord::Migration[8.1]
  def change
    create_table :community_members, primary_key: [ :community_id, :user_id ] do |t|
      t.references :community, type: :uuid, null: false, index: false, foreign_key: { on_delete: :cascade }
      t.references :user, type: :uuid, null: false, foreign_key: { on_delete: :cascade }
      t.string :role, null: false, default: "member"
      t.datetime :joined_at, null: false, default: -> { "CURRENT_TIMESTAMP" }

      t.check_constraint "role IN ('owner', 'moderator', 'member')", name: "community_members_role_check"
    end
  end
end
