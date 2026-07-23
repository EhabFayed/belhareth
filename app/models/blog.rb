class Blog < ApplicationRecord
  extend Enumerize

  validates :title_ar, :title_en, presence: true
  validates :slug, presence: true, uniqueness: true
  validates :slug_ar, uniqueness: true, presence: true
  validates :blog_photos, length: { maximum: 2, message: "can have at most 2 photos" }

  enumerize :category, in: {
    all: 0,
    knee: 1,
    hip: 2,
    trauma: 3,
    recovery: 4,
    general: 5
  }

  scope :not_deleted, -> { where(is_deleted: false).order(created_at: :desc) }
  scope :published, -> { where(is_deleted: false, is_published: true).order(created_at: :desc) }

  has_many :faqs, as: :parentable, dependent: :destroy
  has_many :contents, as: :parentable, dependent: :destroy
  has_many :blog_photos, dependent: :destroy
  accepts_nested_attributes_for :blog_photos, allow_destroy: true, reject_if: :all_blank

  def self.find_by_any_slug(slug)
    find_by("slug = :s OR slug_ar = :s", s: slug)
  end
end
