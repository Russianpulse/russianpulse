# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20160708194258) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "ab_tests", force: :cascade do |t|
    t.string   "title"
    t.string   "path"
    t.text     "ga_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "blogs", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.string   "slug",                               null: false
    t.text     "feed_url"
    t.text     "avatar_url"
    t.datetime "checked_at"
    t.string   "fetch_type"
    t.float    "posts_per_hour"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.text     "text_cleanup_rules"
    t.boolean  "featured"
    t.float    "rating",             default: 0.0,   null: false
    t.boolean  "hide_source_url",    default: false, null: false
    t.string   "category"
  end

  add_index "blogs", ["featured"], name: "index_blogs_on_featured", using: :btree
  add_index "blogs", ["rating"], name: "index_blogs_on_rating", using: :btree
  add_index "blogs", ["slug"], name: "index_blogs_on_slug", unique: true, using: :btree

  create_table "comments", force: :cascade do |t|
    t.string   "title",            limit: 50, default: ""
    t.text     "comment"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.integer  "user_id"
    t.string   "role",                        default: "comments"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["commentable_id"], name: "index_comments_on_commentable_id", using: :btree
  add_index "comments", ["commentable_type"], name: "index_comments_on_commentable_type", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "post_digests", force: :cascade do |t|
    t.string   "title"
    t.string   "slug",        null: false
    t.text     "description"
    t.text     "post_ids"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "post_digests", ["slug"], name: "index_post_digests_on_slug", unique: true, using: :btree

  create_table "post_teasers", force: :cascade do |t|
    t.text     "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "posts", force: :cascade do |t|
    t.integer  "blog_id"
    t.text     "title"
    t.text     "body"
    t.integer  "views",          default: 0,     null: false
    t.text     "source_url"
    t.datetime "accessed_at"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.text     "source_html"
    t.text     "tags_list"
    t.string   "slug_id"
    t.boolean  "top",            default: false
    t.text     "picture_url"
    t.text     "related_ids"
    t.string   "friendly_param"
    t.integer  "comments_count", default: 0,     null: false
    t.datetime "blocked_at"
    t.text     "block_reason"
  end

  add_index "posts", ["comments_count"], name: "index_posts_on_comments_count", using: :btree
  add_index "posts", ["created_at"], name: "index_posts_on_created_at", using: :btree
  add_index "posts", ["slug_id"], name: "index_posts_on_slug_id", unique: true, using: :btree
  add_index "posts", ["top"], name: "index_posts_on_top", using: :btree
  add_index "posts", ["views"], name: "index_posts_on_views", using: :btree

  create_table "snippets", force: :cascade do |t|
    t.string   "key",        null: false
    t.text     "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text     "v2"
  end

  add_index "snippets", ["key"], name: "index_snippets_on_key", unique: true, using: :btree

  create_table "tags", force: :cascade do |t|
    t.string   "title"
    t.string   "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text     "post_ids"
    t.text     "aliases"
  end

  add_index "tags", ["slug"], name: "index_tags_on_slug", unique: true, using: :btree

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
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "posts", "blogs"
end
