class Bus < ApplicationRecord
  validates :bus_number, presence: true, uniqueness: true
  validates :capacity, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :status, presence: true, inclusion: { in: [ "active", "inactive", "maintenance" ] }
  validates :bus_color, presence: true
end
