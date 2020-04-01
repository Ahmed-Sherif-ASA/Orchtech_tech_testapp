class UsersController < ApplicationController
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    response_email = Apilayer::Mailbox.check(user_params[:email])
    if response_email["format_valid"]
      if @user.save
        if response_email["smtp_check"]
          flash[:success] = "Valid"
          redirect_to root_path
        else
          flash[:danger] = "SMTP_CHECK FAILED"
          redirect_to root_path
        end
      else
        flash[:danger] = "Invalid entry(My validations)"
        redirect_to root_path
      end
    else
      flash[:danger] = "Invalid entry(API)"
      redirect_to root_path
    end
  end

  
  
  private 
  def user_params
    params.require(:user).permit(:email, :password)
  end
  def set_user
    @user = User.find(params[:id])
  end

end