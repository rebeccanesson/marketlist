# == Schema Information
# Schema version: 20110318153820
#
# Table name: users
#
#  id                        :integer         not null, primary key
#  name                      :string(255)
#  email                     :string(255)
#  created_at                :datetime
#  updated_at                :datetime
#  encrypted_password        :string(255)
#  salt                      :string(255)
#  admin                     :boolean
#  organic                   :boolean
#  address_1                 :string(255)
#  address_2                 :string(255)
#  city                      :string(255)
#  state                     :string(255)
#  zipcode                   :string(255)
#  phone                     :string(255)
#  reset_password_code       :string(255)
#  reset_password_code_until :datetime
#

class User < ActiveRecord::Base
  attr_accessor   :password
  attr_accessible :name, :email, :password, :password_confirmation, :admin, :organic, 
                  :address_1, :address_2, :city, :state, :zipcode, :phone, 
                  :reset_password_code
  
  has_many :commitments, :dependent => :destroy
  has_many :invoices
  
  validates :name, :presence => true,
                   :length   => { :maximum => 50 }
  
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, :presence => true, 
                    :format => {:with => email_regex}, 
                    :uniqueness => {:case_sensitive => false}
                    
  validates :address_1, :presence => true
  validates :city, :presence => true
  validates :state, :presence => true
  validates :zipcode, :presence => true
  validates :phone, :presence => true
                    
  validates :password, :presence     => true,
                       :confirmation => true,
                       :length       => { :within => 6..40 },
                       :unless       => Proc.new { |u| !u.encrypted_password.blank? }
  
  before_save :encrypt_password
  
  # Return true if the user's password matches the submitted password.
  def has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password)
  end
  
  def self.authenticate(email, submitted_password)
    user = find_by_email(email)
    return nil  if user.nil?
    return user if user.has_password?(submitted_password)
  end
  
  def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    (user && user.salt == cookie_salt) ? user : nil
  end
  
  def commitments_for_order_listing(order_listing)
    commitments.select { |c| c.order_listing == order_listing }
  end

  private

  def encrypt_password
    return if password.blank? 
    self.salt = make_salt if new_record?
    self.encrypted_password = encrypt(password)
  end

  def encrypt(string)
    secure_hash("#{salt}--#{string}")
  end
  
  def make_salt
    secure_hash("#{Time.zone.now.utc}--#{password}")
  end

  def secure_hash(string)
    Digest::SHA2.hexdigest(string)
  end
  
  
end
