class PagesController < ApplicationController
  before_filter :try_admin, :only => [:dashboard]

  def home
    @book = Book.new
    @socialicons = Socialicon.all
  end

  def faq
  end

  def about
  end

  def shipping_and_payment
  end

  def dashboard
    @bookprices = Bookprice.all
    @bookprice = Bookprice.new
    @deliveries = Delivery.all
    @delivery = Delivery.new
    @orders = Order.all
    @phgallery = Phgallery.find_by_kind("homepage")
    @socialicons = Socialicon.all
    @users = User.all
  end

  private
  def try_admin
    authenticate_user!

    if current_user.admin?
      return
    else
      redirect_to root_url # or whatever
    end
  end
end