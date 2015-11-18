class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_and_belongs_to_many :phoenixes
  has_many :owned_phoenixes, class_name: 'Phoenix', foreign_key: 'owner_id'

  validates_presence_of :username
end
