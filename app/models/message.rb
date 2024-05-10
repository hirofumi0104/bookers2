class Message < ApplicationRecord
  belongs_to :user
  belongs_to :book
  belongs_to :room
  validates :content, presence: true, length: { maximum:140 }
end
