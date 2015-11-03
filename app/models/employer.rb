class Employer < ActiveRecord::Base
  has_many :users
  
  validates :email, :username, :password_hash, :registration_token, presence: true
  validates :email, email: true, uniqueness: true
  validates :username, uniqueness: true, length: { in: 8..32 }
end
