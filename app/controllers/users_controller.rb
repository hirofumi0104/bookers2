class UsersController < ApplicationController
  def index
     @user = current_user
     @book = Book.new
     @books = Book.all
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