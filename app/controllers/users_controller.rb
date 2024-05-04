class UsersController < ApplicationController
  def index
     @user = current_user
     @book = Book.new
     @books = Book.all
     @following_users = @user.following_users
     @follower_users = @user.follower_users
  end
  
  def show
    @user = User.find(params[:id])
    @book = Book.new
    @books = @user.books 
  end
  
  
  def edit
    is_matching_login_user
    @user = User.find(params[:id])  
  end
  
  def update
    is_matching_login_user
    @user =  User.find(params[:id])
   if @user.update(user_params)
    flash[:notice] ="successfully"
    redirect_to user_path(@user)
   else
      render :edit
   end
  end
  
  def follows
   user = User.find(params[:id])
   @users = user.following_users
  end

  def followers
   user = User.find(params[:id])
   @user = user.follower_users
  end
  
  private

  def user_params
    params.require(:user).permit(:name, :profile_image, :introduction)
  end
  
  def is_matching_login_user
    user = User.find(params[:id])
    unless user.id == current_user.id
      redirect_to user_path(current_user)
    end  
  end
end