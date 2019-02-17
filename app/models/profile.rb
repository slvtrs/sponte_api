class Profile < ApplicationRecord
  has_many :devices
  has_many :posts

  def get_time_zone
    time_zone = 'Eastern Time (US & Canada)'
    if self.time_zone.present?
      time_zone = self.time_zone 
    end
    time_zone 
  end

end
