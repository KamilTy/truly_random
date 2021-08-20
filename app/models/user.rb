class User < ApplicationRecord
  # Devise modules
  # there is 1 more that can be added: :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :confirmable, :lockable,
         :timeoutable, :trackable
end
