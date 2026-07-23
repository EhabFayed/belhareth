class PagesController < ApplicationController
  def home
    @operations = Operation.published.reorder(:id).limit(4)
  end

  def about
  end

  def faq
    @faqs = Faq.global.published.reorder(:id)
  end

  def contact
  end
end
