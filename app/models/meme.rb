class Meme < ApplicationRecord
  belongs_to :author, class_name: "User"
  # Optional: a meme without a community lives only on the author's profile.
  belongs_to :community, optional: true

  has_many :media, -> { order(:position) }, class_name: "MemeMedia", dependent: :delete_all, inverse_of: :meme
  has_many :meme_tags, dependent: :delete_all
  has_many :tags, through: :meme_tags
  has_many :laughs, dependent: :delete_all
  has_many :comments

  scope :visible, -> { where(deleted_at: nil, removed_at: nil) }
  scope :recent, -> { order(created_at: :desc) }

  def deleted? = deleted_at.present?
  def removed? = removed_at.present?

  def soft_delete
    update(deleted_at: Time.current)
  end

  def remove_by_moderator
    update(removed_at: Time.current)
  end
end
