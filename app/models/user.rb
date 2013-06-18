class User < ActiveRecord::Base
  has_many :players, dependent: :destroy

  devise :database_authenticatable, :registerable, :validatable

  attr_accessible :username, :email, :password, :password_confirmation

  validates_presence_of :username, :email, :token
  validates_uniqueness_of :username, :email

  before_validation do |user|
    user.token ||= SecureRandom.base64(20)
  end
end
