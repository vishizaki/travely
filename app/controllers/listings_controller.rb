class ListingsController < ApplicationController
  before_action :create_stop, only: [:index, :new]
  skip_after_action :verify_authorized, only: [:new]

  def index
    @items_filtered = []
    @user_stops = current_user.stops
    @user_stops.each do |stop|
      items = policy_scope(Item)
      items = Item.joins(listings: :stop).where(stops: { city: stop.city }).where("start_date <= ?", stop.end_date).where("end_date >= ?", stop.start_date)
      @items_filtered << { items: items, city: stop.city, photo: stop.photo, start_date: stop.start_date, end_date: stop.end_date, id: stop.id }
    end
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

  def listing_params
    params.require(:listing).permit(:item_id, :stop_id)
  end
end

# def new
  #   @item = Item.new
  #   @listing = Listing.new
  #   authorize(@listing)
  # end

  # def create

  #   @item = Item.new(name: params[:listing][:item][:name], description: params[:listing][:item][:description], photo: params[:listing][:item][:photo])
  #   array_of_stop_ids = params[:listing][:stop_id].reject { |elt| elt == "" }
  #   array_of_stop_ids.each do |stop_id|
  #     # todo: create a listing for every stop id
  #     @listing = Listing.new(listing_params)
  #     @listing.stop_id = stop_id
  #     @item.user = @listing.stop.user
  #     @listing.item = @item
  #     authorize(@listing)
  #     @listing.save
  #   end

  #   if @listing.save
  #     redirect_to dashboard_path
  #   else
  #     render :new
  #   end
  #   # @item.user = @listing.stop.user
  # end
