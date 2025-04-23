class UserNotification < ApplicationRecord
  belongs_to :user

  validates :notification_type, presence: true
  validates :title, presence: true
  validates :body, presence: true

  scope :unread, -> { where(read_at: nil) }
  scope :read, -> { where.not(read_at: nil) }

  def mark_as_read!
    update!(read_at: Time.current)
  end

  def mark_as_unread!
    update!(read_at: nil)
  end
end
