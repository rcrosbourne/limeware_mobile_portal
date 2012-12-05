class User < ActiveRecord::Base
  attr_accessible :email, :name
  LIME_EMAIL_REGEX = /\A[\w+\-.]+@(time4)?lime+\.com+\z/i
  validates :name, presence: true, length: {maximum: 50, minimum: 3}
  validates :email, presence: true, format: { with: LIME_EMAIL_REGEX, message: "is not a valid LIME email"},
            uniqueness: {case_sensitive: false}
  before_save :create_remember_token

  def create_remember_token
    self.remember_token = SecureRandom.urlsafe_base64
  end

  def self.ad_authenticate(user_name_or_email, password)
    if user_name_or_email.include? "@"
      user_name_or_email = user_name_or_email.split("@").first
    end
    if user_name_or_email.empty? || password.empty?
      raise ArgumentError, "User name/email or Password cannot be empty"
    else
      #authenticate against lime ad
      require "net/ldap"
      domain = APP_CONFIG[:domain]
      ldap = Net::LDAP.new
      ldap.host =  APP_CONFIG[:ldap_host]
      ldap.port = APP_CONFIG[:ldap_port]
      ldap.auth "#{domain}\\#{user_name_or_email}", "#{password}"
      ldap.bind
    end
  end
  def self.authorize(email,password  )
    find_by_email(email) if ad_authenticate(email,password)
  end
end