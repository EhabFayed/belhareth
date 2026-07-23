module Admin
  class SessionsController < BaseController
    skip_before_action :require_login, only: [:new, :create, :signup, :register]

    def new
      redirect_to admin_root_path if current_admin
    end

    def create
      user = User.find_by(email: params[:email])
      if user&.authenticate(params[:password])
        unless user.approved?
          flash.now[:alert] = "Your account is awaiting approval by an admin."
          return render :new, status: :unprocessable_entity
        end
        session[:admin_user_id] = user.id
        redirect_to admin_root_path, notice: "Welcome back, #{user.name}."
      else
        flash.now[:alert] = "Invalid email or password."
        render :new, status: :unprocessable_entity
      end
    end

    # Sign-up: self-service registration, gated by the @milaknights.com email
    # rule. New accounts are NOT signed in — an existing admin must approve
    # them on the Users page first.
    def signup
      redirect_to admin_root_path if current_admin
      @user = User.new
    end

    def register
      @user = User.new(register_params)
      if @user.save
        redirect_to admin_login_path,
                    notice: "Account created. An admin has to approve it before you can sign in."
      else
        flash.now[:alert] = @user.errors.full_messages.to_sentence
        render :signup, status: :unprocessable_entity
      end
    end

    def destroy
      session.delete(:admin_user_id)
      redirect_to admin_login_path, notice: "Signed out."
    end

    private

    def register_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
  end
end
