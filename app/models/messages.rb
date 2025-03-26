class Message < ApplicationRecord
  belongs_to :user
  belongs_to :route, optional: true

  validates :content, presence: true
  validates :message_type, presence: true
end
