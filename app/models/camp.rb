class Camp < ApplicationRecord
  has_many :reservations, dependent: :destroy

  validates :name, presence: true
  validates :capacity, presence: true, numericality: { only_integer: true, greater_than: 0 }

  def accepts?(reservation)
    CapacityCheck.fits?(intervals_including(reservation), capacity)
  end

  private

  def intervals_including(reservation)
    others = reservations.overlapping(reservation.start_date, reservation.end_date)
    others = others.where.not(id: reservation.id) if reservation.persisted?

    others.map { |other| other.to_interval } + [ reservation.to_interval ]
  end
end
