# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_10_27_000018) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "citext"
  enable_extension "pg_catalog.plpgsql"

  create_table "blocks", primary_key: ["blocker_id", "blocked_id"], force: :cascade do |t|
    t.uuid "blocker_id", null: false
    t.uuid "blocked_id", null: false
    t.datetime "created_at", null: false
    t.index ["blocked_id"], name: "index_blocks_on_blocked_id"
    t.check_constraint "blocker_id <> blocked_id", name: "blocks_not_self_check"
  end

  create_table "comments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "meme_id", null: false
    t.uuid "author_id", null: false
    t.uuid "parent_id"
    t.text "body", null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_comments_on_author_id"
    t.index ["meme_id", "created_at"], name: "index_comments_on_meme_id_and_created_at"
    t.index ["parent_id"], name: "index_comments_on_parent_id"
  end

  create_table "communities", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.citext "slug", null: false
    t.string "name", null: false
    t.text "description"
    t.string "avatar_url"
    t.uuid "owner_id", null: false
    t.boolean "is_private", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_id"], name: "index_communities_on_owner_id"
    t.index ["slug"], name: "index_communities_on_slug", unique: true
  end

  create_table "community_members", primary_key: ["community_id", "user_id"], force: :cascade do |t|
    t.uuid "community_id", null: false
    t.uuid "user_id", null: false
    t.string "role", default: "member", null: false
    t.datetime "joined_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["user_id"], name: "index_community_members_on_user_id"
    t.check_constraint "role::text = ANY (ARRAY['owner'::character varying, 'moderator'::character varying, 'member'::character varying]::text[])", name: "community_members_role_check"
  end

  create_table "follows", primary_key: ["follower_id", "followed_id"], force: :cascade do |t|
    t.uuid "follower_id", null: false
    t.uuid "followed_id", null: false
    t.datetime "created_at", null: false
    t.index ["followed_id"], name: "index_follows_on_followed_id"
    t.check_constraint "follower_id <> followed_id", name: "follows_not_self_check"
  end

  create_table "laughs", primary_key: ["user_id", "meme_id"], force: :cascade do |t|
    t.uuid "user_id", null: false
    t.uuid "meme_id", null: false
    t.datetime "created_at", null: false
    t.index ["meme_id", "created_at"], name: "index_laughs_on_meme_id_and_created_at"
  end

  create_table "meme_media", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "meme_id", null: false
    t.integer "position", default: 0, null: false
    t.string "media_url", null: false
    t.string "media_type", null: false
    t.integer "width"
    t.integer "height"
    t.text "alt_text"
    t.datetime "created_at", null: false
    t.index ["meme_id", "position"], name: "index_meme_media_on_meme_id_and_position", unique: true
    t.check_constraint "\"position\" >= 0", name: "meme_media_position_check"
    t.check_constraint "media_type::text = ANY (ARRAY['image'::character varying, 'gif'::character varying, 'video'::character varying]::text[])", name: "meme_media_media_type_check"
  end

  create_table "meme_tags", primary_key: ["meme_id", "tag_id"], force: :cascade do |t|
    t.uuid "meme_id", null: false
    t.uuid "tag_id", null: false
    t.datetime "created_at", null: false
    t.index ["tag_id"], name: "index_meme_tags_on_tag_id"
  end

  create_table "memes", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "author_id", null: false
    t.uuid "community_id"
    t.text "caption"
    t.integer "laugh_count", default: 0, null: false
    t.datetime "deleted_at"
    t.datetime "removed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id", "created_at"], name: "index_memes_on_author_id_and_created_at"
    t.index ["community_id", "created_at"], name: "index_memes_on_community_id_and_created_at"
    t.index ["created_at"], name: "index_memes_on_created_at_visible", where: "((deleted_at IS NULL) AND (removed_at IS NULL))"
    t.check_constraint "laugh_count >= 0", name: "memes_laugh_count_check"
  end

  create_table "moderation_actions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "moderator_id", null: false
    t.uuid "report_id"
    t.string "action", null: false
    t.string "target_type", null: false
    t.uuid "target_id", null: false
    t.text "reason"
    t.datetime "expires_at"
    t.datetime "created_at", null: false
    t.index ["moderator_id"], name: "index_moderation_actions_on_moderator_id"
    t.index ["report_id"], name: "index_moderation_actions_on_report_id"
    t.index ["target_type", "target_id"], name: "index_moderation_actions_on_target"
    t.check_constraint "action::text = ANY (ARRAY['remove'::character varying, 'warn'::character varying, 'suspend'::character varying, 'ban'::character varying]::text[])", name: "moderation_actions_action_check"
    t.check_constraint "target_type::text = ANY (ARRAY['Meme'::character varying, 'Comment'::character varying, 'User'::character varying]::text[])", name: "moderation_actions_target_type_check"
  end

  create_table "notifications", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.uuid "actor_id", null: false
    t.string "kind", null: false
    t.string "target_type"
    t.uuid "target_id"
    t.datetime "read_at"
    t.datetime "created_at", null: false
    t.index ["actor_id"], name: "index_notifications_on_actor_id"
    t.index ["user_id", "created_at"], name: "index_notifications_on_user_id_and_created_at"
    t.index ["user_id", "kind", "target_type", "target_id"], name: "index_notifications_for_grouping"
    t.index ["user_id"], name: "index_notifications_unread", where: "(read_at IS NULL)"
    t.check_constraint "kind::text = ANY (ARRAY['laugh'::character varying, 'comment'::character varying, 'follow'::character varying]::text[])", name: "notifications_kind_check"
  end

  create_table "plans", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "slug", null: false
    t.string "name", null: false
    t.integer "price_cents", null: false
    t.string "interval", null: false
    t.jsonb "perks", default: {}, null: false
    t.boolean "is_active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_plans_on_slug", unique: true
    t.check_constraint "\"interval\"::text = ANY (ARRAY['month'::character varying, 'year'::character varying]::text[])", name: "plans_interval_check"
    t.check_constraint "price_cents >= 0", name: "plans_price_cents_check"
  end

  create_table "ranking_entries", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "subject_type", null: false
    t.uuid "subject_id", null: false
    t.string "period", null: false
    t.date "period_start", null: false
    t.integer "position", null: false
    t.integer "score", default: 0, null: false
    t.datetime "computed_at", null: false
    t.datetime "created_at", null: false
    t.index ["subject_type", "period", "period_start", "position"], name: "index_ranking_entries_for_leaderboard"
    t.index ["subject_type", "subject_id", "period", "period_start"], name: "index_ranking_entries_uniqueness", unique: true
    t.check_constraint "\"position\" > 0", name: "ranking_entries_position_check"
    t.check_constraint "period::text = ANY (ARRAY['week'::character varying, 'month'::character varying]::text[])", name: "ranking_entries_period_check"
    t.check_constraint "subject_type::text = ANY (ARRAY['User'::character varying, 'Community'::character varying]::text[])", name: "ranking_entries_subject_type_check"
  end

  create_table "reports", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "reporter_id", null: false
    t.string "target_type", null: false
    t.uuid "target_id", null: false
    t.uuid "community_id"
    t.string "reason", null: false
    t.string "status", default: "open", null: false
    t.uuid "resolved_by_id"
    t.datetime "resolved_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["community_id", "status"], name: "index_reports_on_community_id_and_status"
    t.index ["reporter_id"], name: "index_reports_on_reporter_id"
    t.index ["status", "created_at"], name: "index_reports_on_status_and_created_at"
    t.index ["target_type", "target_id"], name: "index_reports_on_target"
    t.check_constraint "reason::text = ANY (ARRAY['spam'::character varying, 'hate'::character varying, 'nudity'::character varying, 'other'::character varying]::text[])", name: "reports_reason_check"
    t.check_constraint "status::text = ANY (ARRAY['open'::character varying, 'resolved'::character varying, 'dismissed'::character varying]::text[])", name: "reports_status_check"
    t.check_constraint "target_type::text = ANY (ARRAY['Meme'::character varying, 'Comment'::character varying, 'User'::character varying]::text[])", name: "reports_target_type_check"
  end

  create_table "subscriptions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.uuid "plan_id", null: false
    t.string "status", null: false
    t.datetime "current_period_end"
    t.string "provider_ref"
    t.datetime "canceled_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["plan_id"], name: "index_subscriptions_on_plan_id"
    t.index ["provider_ref"], name: "index_subscriptions_on_provider_ref", unique: true
    t.index ["user_id"], name: "index_subscriptions_on_user_id"
    t.index ["user_id"], name: "index_subscriptions_one_current_per_user", unique: true, where: "((status)::text = ANY ((ARRAY['active'::character varying, 'past_due'::character varying])::text[]))"
    t.check_constraint "status::text = ANY (ARRAY['active'::character varying, 'past_due'::character varying, 'canceled'::character varying]::text[])", name: "subscriptions_status_check"
  end

  create_table "tags", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "slug", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.index ["slug"], name: "index_tags_on_slug", unique: true
    t.check_constraint "slug::text = lower(slug::text)", name: "tags_slug_lowercase_check"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.citext "username", null: false
    t.citext "email", null: false
    t.string "password_digest", null: false
    t.string "display_name"
    t.string "avatar_url"
    t.text "bio"
    t.string "status", default: "active", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
    t.check_constraint "status::text = ANY (ARRAY['active'::character varying, 'suspended'::character varying, 'banned'::character varying]::text[])", name: "users_status_check"
  end

  add_foreign_key "blocks", "users", column: "blocked_id", on_delete: :cascade
  add_foreign_key "blocks", "users", column: "blocker_id", on_delete: :cascade
  add_foreign_key "comments", "comments", column: "parent_id"
  add_foreign_key "comments", "memes"
  add_foreign_key "comments", "users", column: "author_id"
  add_foreign_key "communities", "users", column: "owner_id"
  add_foreign_key "community_members", "communities", on_delete: :cascade
  add_foreign_key "community_members", "users", on_delete: :cascade
  add_foreign_key "follows", "users", column: "followed_id", on_delete: :cascade
  add_foreign_key "follows", "users", column: "follower_id", on_delete: :cascade
  add_foreign_key "laughs", "memes", on_delete: :cascade
  add_foreign_key "laughs", "users", on_delete: :cascade
  add_foreign_key "meme_media", "memes", on_delete: :cascade
  add_foreign_key "meme_tags", "memes", on_delete: :cascade
  add_foreign_key "meme_tags", "tags", on_delete: :cascade
  add_foreign_key "memes", "communities"
  add_foreign_key "memes", "users", column: "author_id"
  add_foreign_key "moderation_actions", "reports"
  add_foreign_key "moderation_actions", "users", column: "moderator_id"
  add_foreign_key "notifications", "users", column: "actor_id", on_delete: :cascade
  add_foreign_key "notifications", "users", on_delete: :cascade
  add_foreign_key "reports", "communities"
  add_foreign_key "reports", "users", column: "reporter_id"
  add_foreign_key "reports", "users", column: "resolved_by_id"
  add_foreign_key "subscriptions", "plans"
  add_foreign_key "subscriptions", "users"
end
