class CreateCommunities < ActiveRecord::Migration[8.1]
  def change
    create_table :communities, id: :uuid, default: -> { "gen_random_uuid()" } do |t|
      t.citext :slug, null: false
      t.string :name, null: false
      t.text :description
      t.string :avatar_url
      t.references :owner, type: :uuid, null: false, foreign_key: { to_table: :users }
      t.boolean :is_private, null: false, default: false
      t.timestamps

      t.index :slug, unique: true
    end
  end
end
