class ModerationAction < ApplicationRecord
  belongs_to :moderator, class_name: "User"
  # Optional: a moderator can act without a report.
  belongs_to :report, optional: true
  belongs_to :target, polymorphic: true

  # Prefixed because `warn` would clash with Kernel#warn.
  enum :action, { remove: "remove", warn: "warn", suspend: "suspend", ban: "ban" }, prefix: true, validate: true

  validates :target_type, inclusion: { in: Report::TARGET_TYPES }

  scope :in_effect, -> { where(expires_at: nil).or(where(expires_at: Time.current..)) }

  def permanent? = expires_at.nil?
end
