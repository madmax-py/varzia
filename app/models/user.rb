class User < ApplicationRecord
  has_secure_password

  enum :status, { active: "active", suspended: "suspended", banned: "banned" }, default: :active, validate: true

  has_many :memes, foreign_key: :author_id, inverse_of: :author
  has_many :comments, foreign_key: :author_id, inverse_of: :author
  has_many :laughs, dependent: :delete_all
  has_many :laughed_memes, through: :laughs, source: :meme

  has_many :active_follows, class_name: "Follow", foreign_key: :follower_id, inverse_of: :follower, dependent: :delete_all
  has_many :passive_follows, class_name: "Follow", foreign_key: :followed_id, inverse_of: :followed, dependent: :delete_all
  has_many :following, through: :active_follows, source: :followed
  has_many :followers, through: :passive_follows, source: :follower

  has_many :active_blocks, class_name: "Block", foreign_key: :blocker_id, inverse_of: :blocker, dependent: :delete_all
  has_many :passive_blocks, class_name: "Block", foreign_key: :blocked_id, inverse_of: :blocked, dependent: :delete_all
  has_many :blocked_users, through: :active_blocks, source: :blocked

  has_many :owned_communities, class_name: "Community", foreign_key: :owner_id, inverse_of: :owner
  has_many :community_memberships, class_name: "CommunityMember", dependent: :delete_all
  has_many :communities, through: :community_memberships

  has_many :subscriptions
  has_many :notifications, dependent: :delete_all
  has_many :reports, foreign_key: :reporter_id, inverse_of: :reporter

  validates :username, presence: true, uniqueness: true, format: { with: /\A[a-zA-Z0-9_]{3,30}\z/ }
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  normalizes :email, with: ->(email) { email.strip.downcase }
  normalizes :username, with: ->(username) { username.strip.delete_prefix("@") }

  def blocking?(user)
    active_blocks.exists?(blocked_id: user.id)
  end

  def following?(user)
    active_follows.exists?(followed_id: user.id)
  end
end
