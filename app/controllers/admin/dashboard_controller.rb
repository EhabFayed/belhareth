module Admin
  class DashboardController < BaseController
    def index
      @blogs_count      = Blog.not_deleted.count
      @published_blogs  = Blog.published.count
      @operations_count = Operation.not_deleted.count
      @published_ops    = Operation.published.count
      @faqs_count       = Faq.global.where(is_deleted: false).count
      @published_faqs   = Faq.global.published.count
      @inquiries_count  = Inquiry.count
      @inquiries_new    = Inquiry.unhandled.count
      @inquiries_week   = Inquiry.where(created_at: 7.days.ago..).count
    end
  end
end
