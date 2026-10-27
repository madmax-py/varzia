# One laugh per user per meme. Rankings are computed from this table.
class Laugh < ApplicationRecord
  belongs_to :user
  belongs_to :meme, counter_cache: :laugh_count
end
