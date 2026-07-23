module Admin
  class FaqsController < BaseController
    def index
      @faqs = Faq.global.where(is_deleted: false).order(:id)
      @faq  = Faq.new
    end

    def create
      faq = Faq.new(faq_params)
      faq.user_id = current_admin.id
      faq.parentable = find_parent
      if faq.save
        redirect_back fallback_location: admin_faqs_path, notice: "FAQ added."
      else
        redirect_back fallback_location: admin_faqs_path, alert: faq.errors.full_messages.to_sentence
      end
    end

    def update
      faq = Faq.find(params[:id])
      if faq.update(faq_params)
        redirect_back fallback_location: admin_faqs_path, notice: "FAQ updated."
      else
        redirect_back fallback_location: admin_faqs_path, alert: faq.errors.full_messages.to_sentence
      end
    end

    def destroy
      faq = Faq.find(params[:id])
      faq.update(is_deleted: true)
      redirect_back fallback_location: admin_faqs_path, notice: "FAQ deleted."
    end

    private

    def find_parent
      if params[:blog_id]
        Blog.find(params[:blog_id])
      elsif params[:operation_id]
        Operation.find(params[:operation_id])
      end
    end

    def faq_params
      params.require(:faq).permit(:question_ar, :question_en, :answer_ar, :answer_en, :is_published)
    end
  end
end
