class Profile < ApplicationRecord
  has_many :devices
  has_many :posts
end
