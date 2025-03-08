class Route < ApplicationRecord
  has_many :stops, dependent: :destroy

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :latitude, :longitude, presence: true, numericality: true
end
