class BooksController < ApplicationController
before_action :correct_user, only: [:edit, :update]

  def new
    @book = Book.new
  end

#  impressionist :actions => [:show]

  def show
    @book = Book.find(params[:id])
    @booknew = Book.new
    @book_comment = BookComment.new
    @user = current_user
#    impressionist(@book, nil, unique: [:session_hash.to_s])
  end

  def index
    to  = Time.current
    from  = (to - 6.day).at_beginning_of_day
    @books = Book.includes(:favorited_users).
      sort_by {|x|
        x.favorited_users.includes(:favorites).where(updated_at: from...to).size
      }.reverse
  @book = Book.new
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    @books = Book.all
    if @book.save
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      render 'index'
    end
  end

  def edit
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

  private

  def book_params
    params.require(:book).permit(:title, :body)
  end

  def correct_user
    @book = Book.find(params[:id])
    @user = @book.user
    redirect_to(books_path) unless @user == current_user
  end

end

