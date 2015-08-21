class Account < ActiveRecord::Base
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    VALID_NAME_REGEX = /[\w+]+\z/i
    validates :name, presence: true, length: { maximum: 50 }, format: { with: VALID_NAME_REGEX }
    validates :email, presence: true, length: { maximum: 100 }, format: { with: VALID_EMAIL_REGEX }
end
