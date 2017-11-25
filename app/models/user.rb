class User < ApplicationRecord
  has_many :events
  has_many :to_dos

  # Include default devise modules. Others available are:
  # :lockable, :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]
  #:confirmable

  validates :email, :password, presence: true

  before_save :ensure_authentication_token

  def ensure_authentication_token
    if authentication_token.blank?
      self.authentication_token = generate_authentication_token
    end
  end

  def self.from_omniauth(access_token)
    user_info = access_token.info
    user = User.find_by(email: user_info.email)

    user ||= User.create(first_name: user_info.first_name,
                         last_name: user_info.last_name,
                         email: user_info.email,
                         password: Devise.friendly_token[0, 20])

    user
  end

  private

  def generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token unless User.where(authentication_token: token).first
    end
  end
end
