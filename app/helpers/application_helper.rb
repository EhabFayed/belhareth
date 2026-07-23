module ApplicationHelper
  # Clinic facts (from the approved content document) — single source of truth.
  CLINIC_PHONE_DISPLAY = "+966 58 377 7871"
  CLINIC_PHONE_TEL     = "tel:+966583777871"
  CLINIC_WHATSAPP_URL  = "https://wa.me/966583777871"
  CLINIC_EMAIL         = "dr.balhareth@hotmail.com"
  CLINIC_HOURS_SHORT   = "Sat 9:00 AM–12:00 PM · Sun, Tue, Wed 4:00–8:00 PM"
  CLINIC_LOCATION      = "Riyadh, Saudi Arabia — Dr. Sulaiman Al Habib Medical Group, Al Hamra Hospital"
  CLINIC_MAP_QUERY     = "Dr. Sulaiman Al Habib Al Hamra Hospital Riyadh"
  CLINIC_MAP_EMBED     = "https://maps.google.com/maps?q=#{ERB::Util.url_encode(CLINIC_MAP_QUERY)}&z=15&hl=en&output=embed"
  CLINIC_MAP_LINK      = "https://www.google.com/maps?q=#{ERB::Util.url_encode(CLINIC_MAP_QUERY)}"

  # Tags the dashboard's rich-text content may use on public pages.
  RICH_TAGS  = %w[h2 h3 h4 p ul ol li strong em b i u a br blockquote img span div].freeze
  RICH_ATTRS = %w[href src alt title target rel].freeze

  def rtl?
    I18n.locale == :ar
  end

  # Locale-aware read of a bilingual attribute pair (title_en / title_ar …),
  # falling back to English when the Arabic field is blank.
  def loc(record, attr)
    if rtl?
      record.public_send("#{attr}_ar").presence || record.public_send("#{attr}_en")
    else
      record.public_send("#{attr}_en")
    end
  end

  # Slug to use in links for the current locale (both resolve via find_by_any_slug).
  def loc_slug(record)
    rtl? ? (record.slug_ar.presence || record.slug) : record.slug
  end

  # Same page in the other language.
  def locale_switch_path
    other = rtl? ? nil : :ar
    url_for(request.query_parameters.merge(locale: other, only_path: true))
  rescue ActionController::UrlGenerationError
    other ? "/#{other}" : "/"
  end

  def page_title
    t_val = content_for(:title)
    t_val.present? ? "#{t_val} · #{t('meta.title_suffix')}" : t("meta.default_title")
  end

  def nav_link_class(path)
    active = (path == root_path) ? current_page?(root_path) : request.path.sub(%r{\A/ar(?=/|\z)}, "").start_with?(path.sub(%r{\A/ar(?=/|\z)}, ""))
    "nav-link#{' nav-on' if active}"
  end

  def rich(html)
    sanitize(html.to_s, tags: RICH_TAGS, attributes: RICH_ATTRS)
  end

  def operation_photo_url(operation, landing: false)
    photos = operation.operation_photos.select { |p| p.photo.attached? }
    ph = photos.detect { |p| p.is_landing == landing } || photos.first
    url_for(ph.photo) if ph
  end

  def blog_photo_url(blog)
    ph = blog.blog_photos.detect { |p| p.photo.attached? }
    url_for(ph.photo) if ph
  end

  # Articles appear in the chrome only once real published posts exist
  # (client request: keep hidden until content is ready).
  def show_articles_nav?
    return @show_articles_nav if defined?(@show_articles_nav)
    @show_articles_nav = Blog.published.exists?
  end
end
