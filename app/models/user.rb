class User < ActiveRecord::Base
  attr_accessor :remember_token
  before_save {self.email = self.email.downcase}
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                     format: {with: VALID_EMAIL_REGEX},
                     uniqueness: {case_sensitive: false}
                     
  has_secure_password
  validates :password, length: {minimum: 6}
  
  #return the hash digest of the given string.
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
  
  #Return a random token
  def User.new_token
    SecureRandom.urlsafe_base64
  end
  
  #Remember a user in the database for use in persistent sessions.
  def remember
    self.remember_token = User.new_token #remember_token is an attribut in this class
    update_attribute(:remember_digest, User.digest(remember_token)) #meng update di database server, token si User di digest lalu save
  end
  
  #Return true if the given token matches the digest
  def authenticated?(remember_token)
    return false if remember_digest.nil? #this uses the return keyword to return immediately if the remember digest is nil
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end
  
  #forget a user
  def forget
    update_attribute(:remember_digest, nil)
  end
  
  
end
