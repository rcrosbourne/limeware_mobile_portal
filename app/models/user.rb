class User < ActiveRecord::Base
  attr_accessible :email, :name
  LIME_EMAIL_REGEX = /\A[\w+\-.]+@(time4)?lime+\.com+\z/i
  validates :name, presence: true, length: {maximum: 50, minimum: 3}
  validates :email, presence: true, format: { with: LIME_EMAIL_REGEX, message: "is not a valid LIME email"},
            uniqueness: {case_sensitive: false}
end