class Report < ApplicationRecord
  TARGET_TYPES = %w[ Meme Comment User ].freeze

  belongs_to :reporter, class_name: "User"
  belongs_to :target, polymorphic: true
  # Present when the community's mods handle the report instead of the global team.
  belongs_to :community, optional: true
  belongs_to :resolved_by, class_name: "User", optional: true

  has_many :moderation_actions

  enum :reason, { spam: "spam", hate: "hate", nudity: "nudity", other: "other" }, validate: true
  enum :status, { open: "open", resolved: "resolved", dismissed: "dismissed" }, default: :open, validate: true

  validates :target_type, inclusion: { in: TARGET_TYPES }
end
