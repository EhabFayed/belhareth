module Admin
  class SessionsController < BaseController
    skip_before_action :require_login, only: [:new, :create]

    def new
      redirect_to admin_root_path if current_admin
    end

    def create
      user = User.find_by(email: params[:email])
      if user&.authenticate(params[:password])
        session[:admin_user_id] = user.id
        redirect_to admin_root_path, notice: "Welcome back, #{user.name}."
      else
        flash.now[:alert] = "Invalid email or password."
        render :new, status: :unprocessable_entity
      end
    end

    def destroy
      session.delete(:admin_user_id)
      redirect_to admin_login_path, notice: "Signed out."
    end
  end
end
