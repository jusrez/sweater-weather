class User < ApplicationRecord
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true
  validates :password_confirmation, presence: true
  
  has_secure_password 

  before_create do |user|
    user.api_key = SecureRandom.hex
  end
end