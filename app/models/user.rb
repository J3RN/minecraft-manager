class User < ActiveRecord::Base
  has_secure_password

  has_many :phoenixes

  validates_presence_of :username
  validates_presence_of :password
end
