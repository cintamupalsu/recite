class User < ActiveRecord::Base
  attr_accessor :remember_token, :activation_token
  before_save :downcase_email #{self.email = self.email.downcase}
  before_create :create_activation_digest
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                     format: {with: VALID_EMAIL_REGEX},
                     uniqueness: {case_sensitive: false}
                     
  has_secure_password
  validates :password, length: {minimum: 6}, allow_blank: true # allow blank true is for edit section, for create section will handle with has_secure_password
  
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
  #def authenticated?(remember_token)
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    #return false if remember_digest.nil? #this uses the return keyword to return immediately if the remember digest is nil
    return false if digest.nil?
    #BCrypt::Password.new(remember_digest).is_password?(remember_token)
    BCrypt::Password.new(digest).is_password?(token)
  end
  
  #forget a user
  def forget
    update_attribute(:remember_digest, nil)
  end
  
  #Activates Account
  def activate
    update_attribute(:activated, true)
    update_attribute(:activated_at, Time.zone.now)
  end
  
  #Send activation e-mail
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end
  
  private
    def downcase_email
      self.email = email.downcase
    end
    
    def create_activation_digest
      self.activation_token = User.new_token
      self.activation_digest = User.digest(activation_token)
    end
    
end
