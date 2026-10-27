# /sitemap.xml — the hand-maintained file in config/seo/sitemap.xml, served
# verbatim (Screaming Frog export supplied by the client, Oct 2026). The app no
# longer builds the sitemap from Operation/Blog/Faq rows; to change it, replace
# the file and deploy.
#
# It stays out of public/ on purpose: everything in public/ is sent with a
# one-year cache header (right for digest-versioned assets, wrong for a file
# crawlers re-read by its fixed path). This response carries a one-hour public
# cache instead, so a replaced file is live everywhere within the hour.
class SitemapsController < ApplicationController
  def show
    expires_in 1.hour, public: true
    send_file Rails.root.join("config/seo/sitemap.xml"),
              type: "application/xml", disposition: :inline
  end
end
