class ReservationsController < ApplicationController
  def show
    @reservation = Reservation.find(params[:id])
  end

  def new
    @camp = Camp.find(params[:camp_id])
    @reservation = @camp.reservations.build
  end

  def create
    @camp = Camp.find(params[:camp_id])
    @reservation = @camp.reservations.build(reservation_params)

    if @reservation.save
      redirect_to @camp
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @reservation = Reservation.find(params[:id])
  end

  def update
    @reservation = Reservation.find(params[:id])

    if @reservation.update(reservation_params)
      redirect_to @reservation.camp
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def reservation_params
    params.require(:reservation).permit(:name, :amount, :start_date, :end_date)
  end
end
