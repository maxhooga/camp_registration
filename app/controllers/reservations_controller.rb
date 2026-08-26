class ReservationsController < ApplicationController
  def index
    @reservations = Reservation.includes(:camp).order(:start_date, :name)
  end

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
      redirect_to @camp, notice: "Reservation created."
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
      redirect_to @reservation, notice: "Reservation updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    reservation = Reservation.find(params[:id])
    camp = reservation.camp
    reservation.destroy
    redirect_to camp, notice: "Reservation deleted."
  end

  private

  def reservation_params
    params.require(:reservation).permit(:name, :amount, :start_date, :end_date)
  end
end
