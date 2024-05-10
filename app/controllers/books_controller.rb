class BooksController < ApplicationController
  before_action :is_matching_login_user, only: [:edit, :update]

  def new
  end
  
  def create
    @user = current_user
    @books = Book.all
     @book= Book.new(book_params)
     @book.user_id = current_user.id
    if @book.save
       flash[:notice] ="successfully"
      redirect_to book_path(@book.id)
    else
      render :index
    end  
  end
  
  def index
     @user = current_user
    # @books = Book.all
     @book = Book.new
     to = Time.current.at_end_of_day
    from = (to - 6.day).at_beginning_of_day
    @books = Book.includes(:favorited_users).
      sort_by {|x|
        x.favorited_users.includes(:favorites).where(created_at: from...to).size
      }.reverse
  end

  def show
     @book = Book.find(params[:id])
     @user = @book.user
     @book_new = Book.new
     @book_comment = BookComment.new
     @book_detail = Book.find(params[:id])
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
    unless ViewCount.find_by(user_id: current_user.id, book_id: @book_detail.id)
      current_user.view_counts.create(book_id: @book_detail.id)
    end
  end
  
  def edit
    is_matching_login_user
    @book = Book.find(params[:id])
  end
  
  def update
    is_matching_login_user
    @book =  Book.find(params[:id])
    @user = current_user
    if @book.update(book_params)
       flash[:notice] ="successfully"
       redirect_to book_path(@book)
    else
       render :edit
    end
  end
  
  def destroy
    book = Book.find(params[:id])  
    book.destroy  
    redirect_to  '/books'   
  end
  
  def book_params
    params.require(:book).permit(:title, :body)
  end
  
   private
  
  def is_matching_login_user
    book = Book.find(params[:id])
    unless book.user_id == current_user.id
      redirect_to books_path
    end 
  end
 
end
