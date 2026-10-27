# /robots.txt — the hand-maintained file in config/seo/robots.txt, served
# verbatim with a short cache. Served by the app rather than from public/
# because everything in public/ goes out with a one-year cache header, which
# is right for digest-versioned assets but wrong for a file that crawlers and
# SEO tools re-read by its fixed path. To change it, replace the file and
# deploy; it is live everywhere within the hour.
class RobotsController < ApplicationController
  def show
    expires_in 1.hour, public: true
    send_file Rails.root.join("config/seo/robots.txt"),
              type: "text/plain", disposition: :inline
  end
end
