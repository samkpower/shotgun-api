class Authorization < ApplicationRecord
  belongs_to :user

  validates :user_id, :provider, presence: true
end
