# Appointment request from the public booking form (same flow as neuskin's
# Inquiry): stored, then two emails — internal notification + visitor
# confirmation in their language.
class Inquiry < ApplicationRecord
  validates :name, presence: true
  validates :mobile, presence: true,
                     format: { with: /\A\+9665\d{8}\z/, message: :invalid_ksa_mobile }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true

  before_validation :normalize_mobile

  scope :recent, -> { order(created_at: :desc) }
  scope :unhandled, -> { where(handled: false) }

  private

  # Accept "05XXXXXXXX", "5XXXXXXXX", "9665XXXXXXXX", "+9665XXXXXXXX" → +9665XXXXXXXX.
  def normalize_mobile
    return if mobile.blank?

    digits = mobile.gsub(/\D/, "")
    digits = digits.sub(/\A966/, "")
    digits = digits.sub(/\A0/, "")
    self.mobile = "+966#{digits}"
  end
end
