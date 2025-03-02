class Route < ApplicationRecord
  has_many :stops, dependent: :destroy

  validates :name, presence: true
  validates :lat, :long, presence: true, numericality: true
end
