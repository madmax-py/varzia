class CreateLaughs < ActiveRecord::Migration[8.1]
  def change
    create_table :laughs, primary_key: [ :user_id, :meme_id ] do |t|
      t.references :user, type: :uuid, null: false, index: false, foreign_key: { on_delete: :cascade }
      t.references :meme, type: :uuid, null: false, index: false, foreign_key: { on_delete: :cascade }
      t.datetime :created_at, null: false

      # Ranking jobs aggregate laughs per meme within a period.
      t.index [ :meme_id, :created_at ]
    end
  end
end
