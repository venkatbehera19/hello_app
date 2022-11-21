class User < ApplicationRecord
    attr_accessor :remember_token, :activation_token, :reset_token
    before_save { email.downcase! }
    before_create :create_activation_digest

    has_many :microposts ,dependent: :destroy
    has_many :posts , dependent: :destroy
    has_many :active_relationships, class_name: "Relationship",
                                    foreign_key: "follower_id",
                                    dependent: :destroy
    has_many :passive_relationships, class_name: "Relationship",
                                     foreign_key: "followed_id",
                                     dependent: :destroy
    
    has_many :following, through: :active_relationships, source: :followed
    has_many :followers, through: :passive_relationships, source: :follower

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
        # posts
        following_ids = "SELECT followed_id FROM relationships WHERE follower_id = :user_id"
        Post.where("user_id IN (#{following_ids}) OR user_id = :user_id", user_id:id)
        # part_of_feed = "relationships.follower_id = :id or posts.user_id = :id"
        # Posts.joins(user: :followers).where(part_of_feed, { id: id});
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

    # follow a user
    def follow(other_user)
        following << other_user;
    end

    # unfollow a user
    def unfollow(other_user)
        following.delete(other_user)
    end

    # return true if the current user is following the other user.
    def following?(other_user)
        following.include?(other_user)
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