class CommunityMember < ApplicationRecord
  belongs_to :community
  belongs_to :user

  enum :role, { owner: "owner", moderator: "moderator", member: "member" }, default: :member, validate: true

  scope :staff, -> { where(role: [ :owner, :moderator ]) }
end
