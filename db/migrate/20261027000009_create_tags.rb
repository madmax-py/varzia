class CreateTags < ActiveRecord::Migration[8.1]
  def change
    create_table :tags, id: :uuid, default: -> { "gen_random_uuid()" } do |t|
      t.string :slug, null: false
      t.string :name, null: false
      t.datetime :created_at, null: false

      t.index :slug, unique: true
      t.check_constraint "slug = lower(slug)", name: "tags_slug_lowercase_check"
    end
  end
end
