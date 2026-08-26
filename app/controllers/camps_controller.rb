class CampsController < ApplicationController
  def index
    @camps = Camp.order(:name).includes(:reservations)
  end

  def show
    @camp = Camp.find(params[:id])
    @reservations = @camp.reservations.order(:start_date)
    @month_start = (params[:month]&.to_date || Date.current).beginning_of_month
    @calendar_weeks = @camp.calendar_weeks(@month_start)
  end

  def new
    @camp = Camp.new
  end

  def create
    @camp = Camp.new(camp_params)

    if @camp.save
      redirect_to @camp, notice: "Camp created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @camp = Camp.find(params[:id])
  end

  def update
    @camp = Camp.find(params[:id])

    if @camp.update(camp_params)
      redirect_to @camp, notice: "Camp updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    Camp.find(params[:id]).destroy
    redirect_to camps_path, notice: "Camp deleted."
  end

  private

  def camp_params
    params.require(:camp).permit(:name, :capacity)
  end
end
