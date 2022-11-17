class Post < ApplicationRecord
  belongs_to :user
  default_scope -> { order(created_at: :desc) } # lamda function
  # validates :user_id, presence :true
  validates :content, length: {maximum:140}
end
