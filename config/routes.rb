Rails.application.routes.draw do
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  get "sitemap.xml", to: "sitemaps#show", defaults: { format: :xml }

  # ── Public site (server-rendered; English at /, Arabic under /ar) ────────
  scope "(:locale)", locale: /ar/ do
    root "pages#home"

    get "about",   to: "pages#about"
    get "faq",     to: "pages#faq"
    get "contact", to: "pages#contact"

    get "specialties",     to: "conditions#index", as: :specialties
    get "specialties/:id", to: "conditions#show",  as: :specialty

    get "articles",       to: "articles#index"
    get "articles/:slug", to: "articles#show", as: :article

    post "inquiries", to: "inquiries#create", as: :inquiries
  end

  # ── Admin dashboard (session login) ──────────────────────────────────────
  namespace :admin do
    root "dashboard#index"
    get    "login",  to: "sessions#new"
    post   "login",  to: "sessions#create"
    get    "signup", to: "sessions#signup"
    post   "signup", to: "sessions#register"
    delete "logout", to: "sessions#destroy"

    resources :blogs, except: [:show] do
      resources :faqs,     only: [:create, :update, :destroy]
      resources :contents, only: [:create, :update, :destroy]
    end
    resources :operations, except: [:show] do
      resources :faqs,     only: [:create, :update, :destroy]
      resources :contents, only: [:create, :update, :destroy]
    end
    resources :faqs, only: [:index, :create, :update, :destroy]
    resources :inquiries, only: [:index, :update, :destroy]
    resources :users, only: [:index, :create, :destroy] do
      member { patch :approve }
    end
  end

  # ── JSON API for the milaknights dashboard frontend (same as dr_elmunify) ─
  post 'signup', to: 'authentication#signup'
  post 'login',  to: 'authentication#login'
  put  'users/:id', to: 'authentication#update'

  resources :blogs, only: [:index, :show, :create, :update, :destroy] do
    resources :faqs, only: [:index, :create, :update, :destroy]
    resources :contents, only: [:index, :create, :update, :destroy]
  end

  resources :operations, only: [:index, :show, :create, :update, :destroy] do
    resources :faqs, only: [:index, :create, :update, :destroy]
    resources :contents, only: [:index, :create, :update, :destroy]
  end

  get "blogs_landing",      to: "web_site#blogs_landing"
  get "blog_show/",         to: "web_site#blog_show"
  get "operations_landing", to: "web_site#operations_landing"
  get "operation_show/",    to: "web_site#operation_show"
  get "faq_about_us",       to: "web_site#faq_about_us"

  get    "faqs",     to: "faqs#index_without_blog"
  post   "faqs",     to: "faqs#create_without_blog"
  put    "faqs/:id", to: "faqs#update_without_blog"
  delete "faqs/:id", to: "faqs#delete_without_blog"
end
