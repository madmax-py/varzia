class CreateComments < ActiveRecord::Migration[8.1]
  def change
    create_table :comments, id: :uuid, default: -> { "gen_random_uuid()" } do |t|
      t.references :meme, type: :uuid, null: false, index: false, foreign_key: true
      t.references :author, type: :uuid, null: false, foreign_key: { to_table: :users }
      # Null means a root comment.
      t.references :parent, type: :uuid, foreign_key: { to_table: :comments }
      t.text :body, null: false
      t.datetime :deleted_at
      t.timestamps

      t.index [ :meme_id, :created_at ]
    end
  end
end
