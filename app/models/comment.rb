class Comment < ApplicationRecord
  belongs_to :meme
  belongs_to :author, class_name: "User"
  # Optional: a comment without a parent is a root comment.
  belongs_to :parent, class_name: "Comment", optional: true

  has_many :replies, class_name: "Comment", foreign_key: :parent_id, inverse_of: :parent

  validates :body, presence: true
  validate :parent_on_same_meme

  scope :visible, -> { where(deleted_at: nil) }
  scope :roots, -> { where(parent_id: nil) }

  def deleted? = deleted_at.present?

  def soft_delete
    update(deleted_at: Time.current)
  end

  private
    def parent_on_same_meme
      errors.add(:parent, "must belong to the same meme") if parent && parent.meme_id != meme_id
    end
end
