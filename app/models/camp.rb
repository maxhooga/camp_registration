class Camp < ApplicationRecord
  has_many :reservations, dependent: :destroy
end
