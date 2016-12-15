class Event < ApplicationRecord
  belongs_to :user
  validates :start, :end, :name, presence: true
end
