class CreateMemeMedia < ActiveRecord::Migration[8.1]
  def change
    create_table :meme_media, id: :uuid, default: -> { "gen_random_uuid()" } do |t|
      t.references :meme, type: :uuid, null: false, index: false, foreign_key: { on_delete: :cascade }
      t.integer :position, null: false, default: 0
      t.string :media_url, null: false
      t.string :media_type, null: false
      t.integer :width
      t.integer :height
      t.text :alt_text
      t.datetime :created_at, null: false

      t.index [ :meme_id, :position ], unique: true
      t.check_constraint "position >= 0", name: "meme_media_position_check"
      t.check_constraint "media_type IN ('image', 'gif', 'video')", name: "meme_media_media_type_check"
    end
  end
end
