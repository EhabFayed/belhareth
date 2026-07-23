class Content < ApplicationRecord
  validates :content_ar, :content_en, presence: true

  belongs_to :parentable, polymorphic: true
  belongs_to :user

  has_many :content_photos, dependent: :destroy
  # reject blank rows coming from the admin form's empty "new photo" fields
  # (the dashboard API always sends a real photo, so it is unaffected).
  accepts_nested_attributes_for :content_photos, allow_destroy: true,
    reject_if: ->(attrs) { attrs["id"].blank? && attrs["photo"].blank? }
end
