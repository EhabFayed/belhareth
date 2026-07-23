module Admin
  class InquiriesController < BaseController
    def index
      @inquiries = Inquiry.recent
    end

    def update
      inquiry = Inquiry.find(params[:id])
      inquiry.update(handled: params[:handled] == "true")
      redirect_to admin_inquiries_path, notice: inquiry.handled? ? "Marked as handled." : "Marked as new."
    end

    def destroy
      Inquiry.find(params[:id]).destroy
      redirect_to admin_inquiries_path, notice: "Inquiry deleted."
    end
  end
end
