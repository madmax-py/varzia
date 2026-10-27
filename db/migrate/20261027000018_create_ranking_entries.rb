class CreateRankingEntries < ActiveRecord::Migration[8.1]
  def change
    # Derived table: rebuilt by a job from laughs, never written by the app directly.
    create_table :ranking_entries, id: :uuid, default: -> { "gen_random_uuid()" } do |t|
      t.references :subject, type: :uuid, null: false, polymorphic: true, index: false
      t.string :period, null: false
      t.date :period_start, null: false
      t.integer :position, null: false
      t.integer :score, null: false, default: 0
      t.datetime :computed_at, null: false
      t.datetime :created_at, null: false

      t.index [ :subject_type, :subject_id, :period, :period_start ], unique: true, name: "index_ranking_entries_uniqueness"
      t.index [ :subject_type, :period, :period_start, :position ], name: "index_ranking_entries_for_leaderboard"
      t.check_constraint "subject_type IN ('User', 'Community')", name: "ranking_entries_subject_type_check"
      t.check_constraint "period IN ('week', 'month')", name: "ranking_entries_period_check"
      t.check_constraint "position > 0", name: "ranking_entries_position_check"
    end
  end
end
