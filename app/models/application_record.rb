class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  # Ids are random uuids, so first/last would be meaningless without this.
  self.implicit_order_column = "created_at"
end
