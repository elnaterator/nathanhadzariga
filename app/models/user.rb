class User < ActiveRecord::Base
  validates :name, presence: true, format: { with: /\A[\w\s]+\z/i }, length: { maximum: 30 }
  validates :email, presence: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
end
