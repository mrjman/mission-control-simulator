class Admin::UsersController < AdminController
  def index
    @users = User.all
  end

  def destroy
    @user = User.destroy(params[:id])

    if @user.destroyed?
      redirect_to admin_users_path, notice: "Successfully deleted #{@user.email}"
    end
  end
end
