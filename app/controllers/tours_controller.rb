class ToursController < ApplicationController

  before_filter :authenticate_user!
  before_filter :find_tour

  def update
    @tour.update_attribute(params[:tour_name].to_sym, true)

    head :ok, type: "application/json"
  end

  def show
    render json: @tour, root: false
  end

  private

  def find_tour
    @tour = current_user.tour
  end
end

