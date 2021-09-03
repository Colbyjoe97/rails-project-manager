class User < ApplicationRecord
  has_secure_password

  validates :first_name, :last_name, :email, presence: true
  EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]+)\z/i
  validates :email, uniqueness: { case_sensitive: false }, format: { with: EMAIL_REGEX }

  before_create do |user|
    user.email = user.email.downcase
  end
end
