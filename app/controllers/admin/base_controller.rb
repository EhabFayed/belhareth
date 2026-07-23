module Admin
  class BaseController < ApplicationController
    layout "admin"

    before_action :require_login

    helper_method :current_admin

    def current_admin
      @current_admin ||= User.find_by(id: session[:admin_user_id])
    end

    private

    def require_login
      redirect_to admin_login_path, alert: "Please sign in." unless current_admin
    end
  end
end
