class Community < ApplicationRecord
  belongs_to :owner, class_name: "User"

  has_many :members, class_name: "CommunityMember", dependent: :delete_all
  has_many :users, through: :members
  has_many :memes
  has_many :reports

  validates :slug, presence: true, uniqueness: true, format: { with: /\A[a-z0-9-]{3,50}\z/ }
  validates :name, presence: true

  normalizes :slug, with: ->(slug) { slug.strip.downcase }

  def to_param = slug
end
