class CampsController < ApplicationController
  def index
    @camps = Camp.order(:name).includes(:reservations)
  end

  def show
    @camp = Camp.find(params[:id])
    @reservations = @camp.reservations.order(:start_date)
  end

  def new
    @camp = Camp.new
  end

  def create
    @camp = Camp.new(camp_params)

    if @camp.save
      redirect_to @camp
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def camp_params
    params.require(:camp).permit(:name, :capacity)
  end
end
