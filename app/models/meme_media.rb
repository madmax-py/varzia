class MemeMedia < ApplicationRecord
  self.table_name = "meme_media"

  belongs_to :meme

  enum :media_type, { image: "image", gif: "gif", video: "video" }, validate: true

  validates :media_url, presence: true
  validates :position, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, uniqueness: { scope: :meme_id }
  validates :width, :height, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true
end
