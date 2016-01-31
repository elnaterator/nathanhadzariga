class User < ActiveRecord::Base
  validates :name, presence: true, format: { with: /\A[\w\s]+\z/i }, length: { maximum: 30 }
  validates :email, presence: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }

  # model now has password_digest in the DB
  # and we have 2 fields, password, and password_confirmation
  # on create the password and password_confirmation will be required
  has_secure_password
  validates :password_confirmation, presence: true, if: '!password.nil?'

  def admin?
    role == 'ADMIN'
  end
end
