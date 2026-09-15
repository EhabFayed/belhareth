class RobotsController < ApplicationController
  # /robots.txt — served by the app rather than from public/ so it can carry a
  # short cache. Everything in public/ is sent with a one-year cache header,
  # which is right for digest-versioned assets but wrong for a file that
  # crawlers and SEO tools re-read by its fixed path.
  def show
    expires_in 1.hour, public: true
    render layout: false, formats: :text, content_type: "text/plain"
  end
end
