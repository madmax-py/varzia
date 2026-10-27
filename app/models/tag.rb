class Tag < ApplicationRecord
  has_many :meme_tags, dependent: :delete_all
  has_many :memes, through: :meme_tags

  validates :slug, presence: true, uniqueness: true
  validates :name, presence: true

  normalizes :slug, with: ->(slug) { slug.strip.downcase }
end
