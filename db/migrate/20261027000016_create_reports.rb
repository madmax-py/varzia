class CreateReports < ActiveRecord::Migration[8.1]
  def change
    create_table :reports, id: :uuid, default: -> { "gen_random_uuid()" } do |t|
      t.references :reporter, type: :uuid, null: false, foreign_key: { to_table: :users }
      t.references :target, type: :uuid, null: false, polymorphic: true
      # When present, the community's mods resolve the report.
      t.references :community, type: :uuid, index: false, foreign_key: true
      t.string :reason, null: false
      t.string :status, null: false, default: "open"
      t.references :resolved_by, type: :uuid, index: false, foreign_key: { to_table: :users }
      t.datetime :resolved_at
      t.timestamps

      t.index [ :status, :created_at ]
      t.index [ :community_id, :status ]
      t.check_constraint "target_type IN ('Meme', 'Comment', 'User')", name: "reports_target_type_check"
      t.check_constraint "reason IN ('spam', 'hate', 'nudity', 'other')", name: "reports_reason_check"
      t.check_constraint "status IN ('open', 'resolved', 'dismissed')", name: "reports_status_check"
    end
  end
end
