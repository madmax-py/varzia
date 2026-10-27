class MemeTag < ApplicationRecord
  belongs_to :meme
  belongs_to :tag
end
