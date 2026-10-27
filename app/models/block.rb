class Block < ApplicationRecord
  belongs_to :blocker, class_name: "User"
  belongs_to :blocked, class_name: "User"

  validate :not_self

  private
    def not_self
      errors.add(:blocked, "can't be yourself") if blocker_id == blocked_id
    end
end
