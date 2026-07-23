class Faq < ApplicationRecord
  validates :question_ar, presence: true
  validates :question_en, presence: true
  validates :answer_ar, presence: true
  validates :answer_en, presence: true
  belongs_to :parentable, polymorphic: true, optional: true
  belongs_to :user, required: true

  scope :published, -> { where(is_published: true, is_deleted: false) }
  scope :global, -> { where(parentable_id: nil) }
end
