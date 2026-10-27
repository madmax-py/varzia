class CreateSubscriptions < ActiveRecord::Migration[8.1]
  def change
    create_table :subscriptions, id: :uuid, default: -> { "gen_random_uuid()" } do |t|
      t.references :user, type: :uuid, null: false, index: false, foreign_key: true
      t.references :plan, type: :uuid, null: false, foreign_key: true
      t.string :status, null: false
      t.datetime :current_period_end
      # Id of the subscription at the payment gateway.
      t.string :provider_ref
      t.datetime :canceled_at
      t.timestamps

      t.index :user_id
      t.index :user_id, unique: true, where: "status IN ('active', 'past_due')", name: "index_subscriptions_one_current_per_user"
      t.index :provider_ref, unique: true
      t.check_constraint "status IN ('active', 'past_due', 'canceled')", name: "subscriptions_status_check"
    end
  end
end
