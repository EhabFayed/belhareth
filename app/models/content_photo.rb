class ContentPhoto < ApplicationRecord
  belongs_to :content

  has_one_attached :photo

  validates :alt_ar, :alt_en, presence: true
end
