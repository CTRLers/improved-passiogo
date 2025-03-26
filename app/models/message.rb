class Message < ApplicationRecord
  belongs_to :messageable, polymorphic: true

  validates :message_type, presence: true
  validates :content, presence: true
end
