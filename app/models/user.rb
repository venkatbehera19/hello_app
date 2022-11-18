class User < ApplicationRecord
    attr_accessor :remember_token, :activation_token, :reset_token
    before_save { email.downcase! }
    before_create :create_activation_digest

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

    def authenticated?(attribute, token)
        digest = send("#{attribute}_digest") # self.send("#{attribute}_digest")
        return false if digest.nil?
        BCrypt::Password.new(digest).is_password?(token)
    end

    # forget a user
    def forget
        update_attribute(:remember_digest, nil)
    end

    def feed 
        # Post.where("user_id = ?", id);
        posts
    end

    # activate an account
    def activate 
        # update_attribute(:activated, true)
        # update_attribute(:activated_at, Time.zone.now)
        update_columns(activated: true, activated_at: Time.zone.now)
    end

    def send_activation_email 
        UserMailer.account_activation(self).deliver_now
    end

    def create_reset_digest
        self.reset_token = User.new_token 
        update_columns(reset_digest: User.digest(reset_token), reset_sent_at: Time.zone.now)
    end

    def send_password_reset_email 
        UserMailer.password_reset(self).deliver_now
    end

    def password_reset_expired? 
        reset_sent_at < 2.hours.ago
    end

    private 

        # convert email to lowercase
        def downcase_email
            self.email = email.downcase
        end

        # create and assigns the activation token and digest
        def create_activation_digest
            self.activation_token = User.new_token
            self.activation_digest = User.digest(activation_token)
        end
        
end