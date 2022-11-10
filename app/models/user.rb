class User < ApplicationRecord
    before_save { email.downcase! }
    has_many :microposts
    validates :name, presence: true, length: {minimum:3, maximum:50}
    VALID_EMAIL_REGEX = /\A[^@][\w.-]+@[\w.-]+[.][a-z]{2,4}\z/i
    validates :email, presence: true, 
    length: {minimum:3, maximum:255}, 
    format: { with: VALID_EMAIL_REGEX }, uniqueness: true
    validates :password, presence: true, length: {minimum:6, maximum:12}

    has_secure_password
end