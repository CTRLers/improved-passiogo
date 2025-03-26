class Stop < ApplicationRecord
  belongs_to :route
  has_many :messages, as: :messageable, dependent: :destroy
  validates :name, presence: true
  validates :latitude, :longitude, presence: true, numericality: true
end
