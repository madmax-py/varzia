class Notification < ApplicationRecord
  # `type` holds the notification kind, not a subclass name.
  self.inheritance_column = nil

  belongs_to :user
  belongs_to :actor, class_name: "User"
  belongs_to :target, polymorphic: true, optional: true

  enum :type, { laugh: "laugh", comment: "comment", follow: "follow" }, validate: true

  scope :unread, -> { where(read_at: nil) }
  scope :recent, -> { order(created_at: :desc) }

  def read? = read_at.present?

  def mark_as_read
    update(read_at: Time.current) unless read?
  end
end
