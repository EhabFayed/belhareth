class BlogPhoto < ApplicationRecord
  belongs_to :blog
  has_one_attached :photo
end
