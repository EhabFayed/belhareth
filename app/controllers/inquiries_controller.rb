class InquiriesController < ApplicationController
  def create
    inquiry = Inquiry.new(inquiry_params)
    inquiry.preferred_locale = I18n.locale.to_s

    if inquiry.save
      InquiryNotificationJob.perform_later(inquiry.id)
      redirect_back fallback_location: contact_path, notice: t("booking.success")
    else
      redirect_back fallback_location: contact_path,
                    alert: t("booking.error", errors: inquiry.errors.full_messages.to_sentence)
    end
  end

  private

  def inquiry_params
    params.require(:inquiry).permit(:name, :mobile, :email, :reason, :preferred_day, :notes)
  end
end
