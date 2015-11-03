class User < ActiveRecord::Base
  belongs_to :employer
  
  validates :email, :username, :password_hash, presence: true
  validates :email, email: true, uniqueness: true
  validates :username, uniqueness: true, length: { in: 8..32 }
end
