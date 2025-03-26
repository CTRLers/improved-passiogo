class Route < ApplicationRecord
  has_many :stops, dependent: :destroy

  validates :name, presence: true
  validates :latitude, :longitude, presence: true, numericality: true
end
