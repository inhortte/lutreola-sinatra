require 'dm-core'
require 'dm-migrations'
require 'digest'

class Member
  include DataMapper::Resource

  property :id, Serial
  property :username, String, :length => 20, :required => true, :unique => true
  property :email, String, :length => 40, :required => true, :unique => true
  property :encrypted_password, String, :length => 255
  property :salt, String, :length => 255
  property :type, Discriminator
  property :auth_token, String, :length => 25
  property :active, Boolean, :default => false
  property :last_action, DateTime
  property :created_at, DateTime

  attr_accessor :password, :password_confirmation

  validates_presence_of :password
  validates_presence_of :password_confirmation
  validates_length_of :password, :min => 5
  validates_confirmation_of :password

  has 1, :member_info
  has 1, :photographer

  def has_password?(passwd)
    self.encrypted_password == encrypt(passwd)
  end

  before :create do |m|
    m.created_at = Time.now
    make_auth_token
  end
  before :save, :encrypt_password

  private

  def make_auth_token
    chars = ('a'..'z').to_a + ('0'..'9').to_a + ('A'..'Z').to_a
    self.auth_token = (1.upto 19).reduce("") { |m,a| m += chars[rand(chars.length)] }
  end

  def encrypt_password
    self.salt = make_salt if new?
    self.encrypted_password = encrypt(self.password)
  end

  def encrypt(s)
    secure_hash("#{self.salt}--#{s}")
  end

  def make_salt
    secure_hash("#{Time.now.utc}--#{self.password}")
  end

  def secure_hash(s)
    Digest::SHA2.hexdigest(s)
  end
end

class DonatingMember < Member; end
class Admin < Member; end

class MemberInfo
  include DataMapper::Resource

  property :id, Serial
  property :first_name, String, :length => 20
  property :last_name, String, :length => 30
  property :other_names, String, :length => 100
  property :title, String, :length => 20
  property :address, String
  property :city, String, :length => 30
  property :province, String, :length => 30
  property :country, String, :length => 3
  property :postal_code, String, :length => 10
  property :gender, String, :length => 1
  property :age, Integer

  belongs_to :member
end
