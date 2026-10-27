class CreatePlans < ActiveRecord::Migration[8.1]
  def change
    create_table :plans, id: :uuid, default: -> { "gen_random_uuid()" } do |t|
      t.string :slug, null: false
      t.string :name, null: false
      t.integer :price_cents, null: false
      t.string :interval, null: false
      t.jsonb :perks, null: false, default: {}
      t.boolean :is_active, null: false, default: true
      t.timestamps

      t.index :slug, unique: true
      t.check_constraint "price_cents >= 0", name: "plans_price_cents_check"
      t.check_constraint "interval IN ('month', 'year')", name: "plans_interval_check"
    end
  end
end
