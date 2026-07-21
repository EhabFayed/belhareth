Rails.application.routes.draw do
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  root "pages#home"

  get "about",   to: "pages#about"
  get "faq",     to: "pages#faq"
  get "contact", to: "pages#contact"

  get "specialties",     to: "conditions#index", as: :specialties
  get "specialties/:id", to: "conditions#show",  as: :specialty

  # Hidden until real content is available (client request, July 2026):
  # get "articles", to: "pages#articles"
  # get "stories",  to: "pages#stories"
end
