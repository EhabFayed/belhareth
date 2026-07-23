module Admin
  class UsersController < BaseController
    def index
      @pending = User.pending.order(:created_at)
      @users = User.approved.order(:id)
      @user = User.new
    end

    def create
      user = User.new(user_params)
      user.approved = true # created by a signed-in admin
      if user.save
        redirect_to admin_users_path, notice: "User #{user.email} created."
      else
        redirect_to admin_users_path, alert: user.errors.full_messages.to_sentence
      end
    end

    def approve
      user = User.find(params[:id])
      user.update!(approved: true)
      redirect_to admin_users_path, notice: "#{user.email} approved — they can sign in now."
    end

    def destroy
      user = User.find(params[:id])
      if user.id == current_admin.id
        redirect_to admin_users_path, alert: "You can't delete your own account."
      elsif user.approved? && User.approved.count <= 1
        redirect_to admin_users_path, alert: "At least one approved user must remain."
      else
        user.destroy
        redirect_to admin_users_path, notice: "User deleted."
      end
    end

    private

    def user_params
      params.require(:user).permit(:name, :email, :password)
    end
  end
end
