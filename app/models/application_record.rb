class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  self.implicit_order_column = "created_at"

  # Time-ordered ids. The database default (gen_random_uuid) only kicks in
  # for rows inserted without callbacks, such as insert_all or raw SQL.
  before_create :assign_uuid_v7, if: -> { self.class.primary_key == "id" }

  private
    def assign_uuid_v7
      self.id ||= SecureRandom.uuid_v7
    end
end
