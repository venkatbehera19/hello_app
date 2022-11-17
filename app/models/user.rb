class User < ApplicationRecord
    attr_accessor :remember_token

    before_save { email.downcase! }

    has_many :microposts ,dependent: :destroy
    has_many :posts , dependent: :destroy

    validates :name, presence: true, length: {minimum:3, maximum:50}

    VALID_EMAIL_REGEX = /\A[^@][\w.-]+@[\w.-]+[.][a-z]{2,4}\z/i

    validates :email, presence: true, length: {minimum:3, maximum:255}, 
              format: { with: VALID_EMAIL_REGEX }, uniqueness: true
    validates :password, presence: true, length: {minimum:6, maximum:12}, allow_nil: true

    has_secure_password

    class << self 
        def digest(string)
            cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
            BCrypt::Password.create(string, cost: cost)
        end
        # returns a random token
        def new_token 
            SecureRandom.urlsafe_base64
        end
    end

    def remember
        self.remember_token = User.new_token
        update_attribute(:remember_digest, User.digest(remember_token))
    end

    def authenticated?(remember_token)
        return false if remember_digest.nil?
        BCrypt::Password.new(remember_digest).is_password?(remember_token)
    end

    # forget a user
    def forget
        update_attribute(:remember_digest, nil)
    end

    def feed 
        # Post.where("user_id = ?", id);
        posts
    end
end