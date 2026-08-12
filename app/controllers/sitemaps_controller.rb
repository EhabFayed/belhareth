class SitemapsController < ApplicationController
  # /sitemap.xml — every indexable page in both languages, generated from the
  # live content so it never goes stale.
  def show
    base = request.base_url

    @entries = []
    add = ->(en_path, ar_path = nil) do
      ar_path ||= "/ar#{en_path == '/' ? '' : en_path}"
      @entries << { en: "#{base}#{en_path}", ar: "#{base}#{ar_path}" }
    end

    add.call("/")
    add.call("/about")
    add.call("/specialties")
    add.call("/faq")
    add.call("/contact")
    add.call("/articles") if Blog.published.exists?

    Operation.published.reorder(:id).each do |op|
      add.call("/specialties/#{op.slug}", "/ar/specialties/#{ERB::Util.url_encode(op.slug_ar.presence || op.slug)}")
    end
    Blog.published.reorder(:id).each do |blog|
      add.call("/articles/#{blog.slug}", "/ar/articles/#{ERB::Util.url_encode(blog.slug_ar.presence || blog.slug)}")
    end

    render layout: false, formats: :xml
  end
end
