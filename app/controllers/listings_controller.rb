class ListingsController < ApplicationController
  skip_after_action :verify_authorized, only: [:new]
  def index
    @listings = policy_scope(Listing)
    create_stop
  end

  def new
    @item = Item.new
    @listing = Listing.new
  end

  def create

  end

  private

  def create_stop
    @city = params[:city]
    @start_date = params[:start_date]
    @end_date = params[:end_date]
    @stop = Stop.new(city: @city, start_date: @start_date, end_date: @end_date)
    @stop.user = current_user
    @stop.save
  end
end
