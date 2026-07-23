# Booking-form emails — every submission sends TWO mails (neuskin pattern):
# an internal notification to the clinic info address, and a confirmation to
# the visitor in their preferred language (when they left an email).
class LeadMailer < ApplicationMailer
  def inquiry_notification(inquiry)
    @inquiry = inquiry
    mail to: Clinic::INFO_EMAIL,
         subject: "New appointment request — #{inquiry.name} (#{inquiry.reason.presence || 'general'})"
  end

  def inquiry_confirmation(inquiry)
    @inquiry = inquiry
    locale = inquiry.preferred_locale.presence_in(%w[ar en]) || I18n.default_locale
    I18n.with_locale(locale) do
      mail to: inquiry.email, subject: I18n.t("mailer.confirmation.subject")
    end
  end
end
