class User < ActiveRecord::Base
  has_many :players, dependent: :destroy

  devise :database_authenticatable, :registerable, :validatable

  attr_accessible :username, :email, :password, :password_confirmation

  validates_presence_of :username, :email
  validates_uniqueness_of :username, :email
end