class PhotosController < ApplicationController
  layout "places"
  before_action :set_place
  before_action :current_family, only: [:index]

  def index
    redirect_to @place and return unless @place.allow?(@current_family)
    target = @current_family.usage_months.where(usage_records: {place: @place}).includes(:photos)
    if params[:ym].present?
      @month = target.find_by(ym: params[:ym])
      @photos = @month.photos.page(params[:page]).per(15)
    else
      @months = target.page(params[:page]).per(9)
    end
  end

  private
    def set_place
      @place = Place.where(key: params[:place_id]).first
    end
end
