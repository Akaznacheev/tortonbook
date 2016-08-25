class BooksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_book, only: [:show, :edit, :update, :destroy]

  def index
    @books = Book.all
  end

  def show
  end

  def new
    @book = Book.new
  end

  def edit
  end

  def create
    @book = Book.new(book_params)
    @book.save
    (1..Book::BPCOUNT).each do |i|
      @book.bookpages.create
      @book.bookpages[i-1].update(:pagenum => i)
    end
    @phgallery = Phgallery.new(book_id: @book.id)
    @phgallery.save
    @book.phgallery = @phgallery
    redirect_to edit_book_path(@book, :razvorot => 1, :lt => @book.bookpages[0].template, :rt => @book.bookpages[1].template)
  end

  def update
      if @book.update(book_params)
        redirect_to @book, notice: 'Book was successfully updated.'
      else
        render :edit
      end
  end

  def destroy
    @book.destroy
    redirect_to books_url, notice: 'Book was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book
      @book = Book.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def book_params
      params.require(:book).permit(:phgallery, :pagecount, :user_id)
    end
end