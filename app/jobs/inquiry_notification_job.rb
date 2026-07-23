class InquiryNotificationJob < ApplicationJob
  queue_as :default

  # New appointment request -> two emails: internal notification to the clinic
  # info address, and a confirmation to the patient (when they left an email)
  # in their preferred language.
  def perform(inquiry_id)
    inquiry = Inquiry.find_by(id: inquiry_id)
    return unless inquiry

    LeadMailer.inquiry_notification(inquiry).deliver_now
    LeadMailer.inquiry_confirmation(inquiry).deliver_now if inquiry.email.present?
    Rails.logger.info("[InquiryNotification] New inquiry ##{inquiry.id} from #{inquiry.name} (#{inquiry.mobile})")
  end
end
