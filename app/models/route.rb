class Route < ApplicationRecord
  has_many :stops, dependent: :destroy
  has_many :messages, as: :messageable, dependent: :destroy

  # Add the association for the current stop.
  belongs_to :current_stop, class_name: 'Stop', optional: true

  validates :name, presence: true
  validates :latitude, :longitude, presence: true, numericality: true

end
