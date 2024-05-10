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
    @today_book =  @books.created_today
    @yesterday_book = @books.created_yesterday
    @this_week_book = @books.created_this_week
    @last_week_book = @books.created_last_week
    @currentUserEntry = Entry.where(user_id: current_user.id)
    @userEntry = Entry.where(user_id: @user.id)
    unless @user.id == current_user.id
      @currentUserEntry.each do |cu| 
        @userEntry.each do |u| 
          if cu.room_id == u.room_id 
            @isRoom = true
            @roomId = cu.room_id
          end
        end
      end
      if @isRoom
      else
        @room = Room.new
        @entry = Entry.new
      end
    end
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
  
  def search
    @user = User.find(params[:user_id])
    @books = @user.books
    @book = Book.new
    if params[:created_at] == ""
      @search_book = "日付を選択してください"
    else
      create_at = params[:created_at]
      @search_book = @books.where(['created_at LIKE ? ', "#{create_at}%"]).count
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