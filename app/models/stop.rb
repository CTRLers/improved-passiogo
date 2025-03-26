class Stop < ApplicationRecord
  belongs_to :route

  validates :name, presence: true
  validates :latitude, :longitude, presence: true, numericality: true
end
