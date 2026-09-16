module ApplicationHelper
  # Clinic facts (from the approved content document) — single source of truth.
  CLINIC_PHONE_DISPLAY = "+966 50 796 4030"
  CLINIC_PHONE_TEL     = "tel:+966507964030"
  CLINIC_WHATSAPP_URL  = "https://wa.me/966507964030"
  CLINIC_EMAIL         = "dr.balhareth@hotmail.com"
  CLINIC_HOURS_SHORT   = "Sat 9:00 AM–12:00 PM · Sun, Tue, Wed 4:00–8:00 PM"
  CLINIC_LOCATION      = "Riyadh, Saudi Arabia — Dr. Sulaiman Al Habib Medical Group, Al Hamra Hospital"
  CLINIC_MAP_QUERY     = "Dr. Sulaiman Al Habib Al Hamra Hospital Riyadh"
  CLINIC_MAP_EMBED     = "https://maps.google.com/maps?q=#{ERB::Util.url_encode(CLINIC_MAP_QUERY)}&z=15&hl=en&output=embed"
  CLINIC_MAP_LINK      = "https://www.google.com/maps?q=#{ERB::Util.url_encode(CLINIC_MAP_QUERY)}"

  # The doctor's social profiles (shown in the footer and on the contact page).
  SOCIAL_LINKS = {
    instagram: "https://www.instagram.com/dr_balhareth123",
    x:         "https://x.com/dr_balhareth123",
    tiktok:    "https://www.tiktok.com/@dr_balhareth123",
    snapchat:  "https://www.snapchat.com/add/dr_balhareth123",
    facebook:  "https://www.facebook.com/share/19aMUYkkLE/"
  }.freeze

  # Tags the dashboard's rich-text content may use on public pages.
  RICH_TAGS  = %w[h1 h2 h3 h4 p ul ol li strong em b i u a br blockquote img span div].freeze
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

  # Self-canonical for every page: current path without query params (so
  # /articles?category=knee canonicalizes to /articles). Slug pages override
  # via content_for(:canonical) to always use the locale-correct slug.
  def canonical_url
    content_for(:canonical).presence || "#{request.base_url}#{request.path}"
  end

  def alternate_url(locale)
    key = locale == :ar ? :alternate_ar : :alternate_en
    return content_for(key) if content_for?(key)

    path = request.path.sub(%r{\A/ar(?=/|\z)}, "")
    locale == :ar ? "#{request.base_url}/ar#{path == '/' ? '' : path}" : "#{request.base_url}#{path.presence || '/'}"
  end

  def page_title
    t_val = content_for(:title)
    t_val.present? ? "#{t_val} · #{t('meta.title_suffix')}" : t("meta.default_title")
  end

  def nav_link_class(path)
    active = (path == root_path) ? current_page?(root_path) : request.path.sub(%r{\A/ar(?=/|\z)}, "").start_with?(path.sub(%r{\A/ar(?=/|\z)}, ""))
    "nav-link#{' nav-on' if active}"
  end

  # The dashboard editor (and text pasted into it from Word/Docs) often joins
  # words with non-breaking spaces. A whole paragraph of them is one unbreakable
  # line, so the page scrolls sideways (seen on the Arabic articles). Normalize
  # them to regular spaces before sanitizing so the browser can wrap normally.
  NBSP_PATTERN = /&nbsp;|&#160;|&#xa0;|\u00A0/i

  # Cache-busting version for the plain static files in public/ (this app has
  # no asset pipeline). public/ is served with a one-year cache header, so an
  # unversioned "/site.css" stays in returning visitors' browsers after a
  # deploy and CSS/JS fixes never reach them. Appending a digest of the file
  # contents changes the URL whenever the file itself changes, so a deploy is
  # picked up immediately and unchanged files stay cached.
  STATIC_ASSET_VERSIONS = Concurrent::Map.new

  def static_asset(path)
    version = STATIC_ASSET_VERSIONS.fetch_or_store(path) do
      file = Rails.public_path.join(path.delete_prefix("/"))
      File.exist?(file) ? Digest::SHA256.file(file).hexdigest[0, 10] : ""
    end
    version.empty? ? path : "#{path}?v=#{version}"
  end

  def rich(html)
    sanitize(html.to_s.gsub(NBSP_PATTERN, " "), tags: RICH_TAGS, attributes: RICH_ATTRS)
  end

  def operation_photo_url(operation, landing: false)
    photos = operation.operation_photos.select { |p| p.photo.attached? }
    ph = photos.detect { |p| p.is_landing == landing } || photos.first
    url_for(ph.photo) if ph
  end

  # The dashboard stores up to two cover photos per article, one flagged
  # `is_arabic`. Pick the one for the current locale, falling back to any
  # attached photo so an article with a single image still shows it.
  def blog_photo(blog)
    photos = blog.blog_photos.select { |p| p.photo.attached? }
    photos.detect { |p| p.is_arabic == rtl? } || photos.first
  end

  def blog_photo_url(blog)
    ph = blog_photo(blog)
    url_for(ph.photo) if ph
  end

  def blog_photo_alt(blog)
    ph = blog_photo(blog)
    (ph && loc(ph, :alt).presence) || loc(blog, :image_alt_text).presence || loc(blog, :title)
  end

  # Articles appear in the chrome only once real published posts exist
  # (client request: keep hidden until content is ready).
  def show_articles_nav?
    return @show_articles_nav if defined?(@show_articles_nav)
    @show_articles_nav = Blog.published.exists?
  end
end
