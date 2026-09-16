class SitemapsController < ApplicationController
  # /sitemap.xml — every indexable page in both languages, generated from the
  # live content so it never goes stale.
  #
  # `lastmod` is the real updated_at of the content behind each URL; pages with
  # no database-backed content (about, contact) carry no lastmod rather than a
  # fabricated "today", which search engines learn to distrust.
  def show
    base = request.base_url

    @entries = []
    add = lambda do |en_path, ar_path = nil, lastmod: nil, changefreq: "monthly", priority: "0.7"|
      ar_path ||= "/ar#{en_path == '/' ? '' : en_path}"
      @entries << {
        en: "#{base}#{en_path}",
        ar: "#{base}#{ar_path}",
        lastmod: lastmod&.to_date,
        changefreq: changefreq,
        priority: priority
      }
    end

    operations   = Operation.published.reorder(:id).to_a
    blogs        = Blog.published.reorder(:id).to_a
    ops_updated  = operations.map(&:updated_at).max
    blog_updated = blogs.map(&:updated_at).max
    faq_updated  = Faq.global.published.maximum(:updated_at)
    site_updated = [ops_updated, blog_updated, faq_updated].compact.max

    add.call("/",            lastmod: site_updated, changefreq: "weekly",  priority: "1.0")
    add.call("/specialties", lastmod: ops_updated,  changefreq: "weekly",  priority: "0.9")
    add.call("/about",                              changefreq: "yearly",  priority: "0.8")
    add.call("/contact",                            changefreq: "yearly",  priority: "0.8")
    add.call("/faq",         lastmod: faq_updated,  changefreq: "monthly", priority: "0.7")
    add.call("/articles",    lastmod: blog_updated, changefreq: "weekly",  priority: "0.8") if blogs.any?

    operations.each do |op|
      add.call("/specialties/#{op.slug}",
               "/ar/specialties/#{ERB::Util.url_encode(op.slug_ar.presence || op.slug)}",
               lastmod: op.updated_at, changefreq: "monthly", priority: "0.9")
    end

    blogs.each do |blog|
      add.call("/articles/#{blog.slug}",
               "/ar/articles/#{ERB::Util.url_encode(blog.slug_ar.presence || blog.slug)}",
               lastmod: blog.updated_at, changefreq: "monthly", priority: "0.7")
    end

    render layout: false, formats: :xml
  end
end
