class Event < ApplicationRecord
  validates :start, :end, :name, presence: true
end
