class Stop < ApplicationRecord
  belongs_to :route

  validates :name, presence: true
  validates :lat, :long, presence: true, numericality: true
end
