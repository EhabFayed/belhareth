class OperationPhoto < ApplicationRecord
  belongs_to :operation
  has_one_attached :photo

  validates :alt_ar, :alt_en, presence: true
end
