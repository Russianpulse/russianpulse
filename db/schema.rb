# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160907194455) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "ab_tests", force: :cascade do |t|
    t.string   "title"
    t.string   "path"
    t.text     "ga_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean  "equal"
  end

  create_table "blogs", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.string   "slug",                                 null: false
    t.text     "feed_url"
    t.text     "avatar_url"
    t.datetime "checked_at"
    t.string   "fetch_type"
    t.float    "posts_per_hour"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.text     "text_cleanup_rules"
    t.boolean  "featured"
    t.float    "rating",             default: 0.0,     null: false
    t.boolean  "hide_source_url",    default: false,   null: false
    t.string   "category"
    t.text     "recent_fetches"
    t.integer  "health_status",      default: 0
    t.string   "default_stream",     default: "inbox", null: false
    t.index ["featured"], name: "index_blogs_on_featured", using: :btree
    t.index ["rating"], name: "index_blogs_on_rating", using: :btree
    t.index ["slug"], name: "index_blogs_on_slug", unique: true, using: :btree
  end

  create_table "comments", force: :cascade do |t|
    t.string   "title",            limit: 50, default: ""
    t.text     "comment"
    t.string   "commentable_type"
    t.integer  "commentable_id"
    t.integer  "user_id"
    t.string   "role",                        default: "comments"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["commentable_id"], name: "index_comments_on_commentable_id", using: :btree
    t.index ["commentable_type"], name: "index_comments_on_commentable_type", using: :btree
    t.index ["user_id"], name: "index_comments_on_user_id", using: :btree
  end

  create_table "follows", force: :cascade do |t|
    t.string   "followable_type",                 null: false
    t.integer  "followable_id",                   null: false
    t.string   "follower_type",                   null: false
    t.integer  "follower_id",                     null: false
    t.boolean  "blocked",         default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["followable_id", "followable_type"], name: "fk_followables", using: :btree
    t.index ["follower_id", "follower_type"], name: "fk_follows", using: :btree
  end

  create_table "post_digests", force: :cascade do |t|
    t.string   "title"
    t.string   "slug",        null: false
    t.text     "description"
    t.text     "post_ids"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["slug"], name: "index_post_digests_on_slug", unique: true, using: :btree
  end

  create_table "post_teasers", force: :cascade do |t|
    t.text     "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "posts", force: :cascade do |t|
    t.integer  "blog_id"
    t.text     "title"
    t.integer  "views",          default: 0,       null: false
    t.text     "source_url"
    t.datetime "accessed_at"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.text     "tags_list"
    t.string   "slug_id"
    t.boolean  "top",            default: false
    t.text     "picture_url"
    t.text     "related_ids"
    t.string   "friendly_param"
    t.integer  "comments_count", default: 0,       null: false
    t.datetime "blocked_at"
    t.text     "block_reason"
    t.string   "stream",         default: "inbox"
    t.text     "body"
    t.index ["comments_count"], name: "index_posts_on_comments_count", using: :btree
    t.index ["created_at"], name: "index_posts_on_created_at", using: :btree
    t.index ["slug_id"], name: "index_posts_on_slug_id", unique: true, using: :btree
    t.index ["top"], name: "index_posts_on_top", using: :btree
    t.index ["views"], name: "index_posts_on_views", using: :btree
  end

  create_table "snippets", force: :cascade do |t|
    t.string   "key",        null: false
    t.text     "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text     "v2"
    t.index ["key"], name: "index_snippets_on_key", unique: true, using: :btree
  end

  create_table "tags", force: :cascade do |t|
    t.string   "title"
    t.string   "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text     "post_ids"
    t.text     "aliases"
    t.index ["slug"], name: "index_tags_on_slug", unique: true, using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",     null: false
    t.string   "encrypted_password",     default: "",     null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,      null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.string   "name"
    t.string   "role",                   default: "user", null: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  add_foreign_key "posts", "blogs"
end
