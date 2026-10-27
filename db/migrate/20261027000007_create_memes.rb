class CreateMemes < ActiveRecord::Migration[8.1]
  def change
    create_table :memes, id: :uuid, default: -> { "gen_random_uuid()" } do |t|
      t.references :author, type: :uuid, null: false, index: false, foreign_key: { to_table: :users }
      # Null means the meme was posted only on the author's profile.
      t.references :community, type: :uuid, index: false, foreign_key: true
      t.text :caption
      t.integer :laugh_count, null: false, default: 0
      t.datetime :deleted_at
      t.datetime :removed_at
      t.timestamps

      t.index [ :author_id, :created_at ]
      t.index [ :community_id, :created_at ]
      t.index :created_at, where: "deleted_at IS NULL AND removed_at IS NULL", name: "index_memes_on_created_at_visible"
      t.check_constraint "laugh_count >= 0", name: "memes_laugh_count_check"
    end
  end
end
