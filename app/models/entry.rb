class Entry < ApplicationRecord
  belongs_to :user
  belongs_to :book
  belongs_to :room
end
