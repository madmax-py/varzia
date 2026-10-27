class CreateMemeTags < ActiveRecord::Migration[8.1]
  def change
    create_table :meme_tags, primary_key: [ :meme_id, :tag_id ] do |t|
      t.references :meme, type: :uuid, null: false, index: false, foreign_key: { on_delete: :cascade }
      t.references :tag, type: :uuid, null: false, foreign_key: { on_delete: :cascade }
      t.datetime :created_at, null: false
    end
  end
end
