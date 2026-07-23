class ApplicationController < ActionController::Base
  around_action :switch_locale

  private

  def switch_locale(&action)
    locale = params[:locale].presence_in(%w[en ar]) || I18n.default_locale
    I18n.with_locale(locale, &action)
  end

  # English URLs stay unprefixed; Arabic pages live under /ar.
  def default_url_options
    { locale: (I18n.locale == I18n.default_locale ? nil : I18n.locale) }
  end
end
