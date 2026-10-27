class Plan < ApplicationRecord
  has_many :subscriptions

  enum :interval, { month: "month", year: "year" }, validate: true

  validates :slug, presence: true, uniqueness: true
  validates :name, presence: true
  validates :price_cents, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  scope :active, -> { where(is_active: true) }
end
