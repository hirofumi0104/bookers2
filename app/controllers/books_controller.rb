class BooksController < ApplicationController
  def new
  end
  
  def create
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
     @book = Book.new
     @books = Book.all
  end

  def show
     @book = Book.find(params[:id])
     @user = @book.user
    @book_new = Book.new
  end
  
  def edit
    is_matching_login_user
    @book = Book.find(params[:id])
  end
  
  def update
    is_matching_login_user
    @book =  Book.find(params[:id])
    if @book.update(book_params)
       flash[:notice] ="successfully"
       redirect_to book_path(@book)
    else
       render :show
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
  def is_matching_login_user
    book = Book.find(params[:id])
    unless book.user_id == current_user.id
      redirect_to user_path(current_user)
    end 
  end
end
