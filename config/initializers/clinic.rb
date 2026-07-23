# Clinic-wide mail settings. The inbox address and SMTP credentials come from
# the environment so they can be set at deploy time — placeholders until the
# real mail provider is decided.
module Clinic
  INFO_EMAIL = ENV.fetch("CLINIC_INFO_EMAIL", "info@balhareth.com").freeze
  MAIL_FROM  = ENV.fetch("MAIL_FROM", "no-reply@balhareth.com").freeze
end

Rails.application.config.to_prepare do
  ApplicationMailer.default from: Clinic::MAIL_FROM
end

# SMTP keys (set these in the environment when the provider is chosen):
#   SMTP_ADDRESS, SMTP_PORT (default 587), SMTP_USERNAME, SMTP_PASSWORD
# Until SMTP_ADDRESS is set, deliveries are no-ops (:test delivery method)
# so the form keeps working without a mail server.
if ENV["SMTP_ADDRESS"].present?
  Rails.application.config.action_mailer.delivery_method = :smtp
  Rails.application.config.action_mailer.smtp_settings = {
    address: ENV["SMTP_ADDRESS"],
    port: ENV.fetch("SMTP_PORT", 587).to_i,
    user_name: ENV["SMTP_USERNAME"],
    password: ENV["SMTP_PASSWORD"],
    authentication: :login,
    enable_starttls_auto: true
  }.compact
  Rails.application.config.action_mailer.raise_delivery_errors = false
else
  Rails.application.config.action_mailer.delivery_method = :test unless Rails.env.test?
end
