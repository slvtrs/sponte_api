class Post < ApplicationRecord
  belongs_to :profile
  has_one_attached :file

  def self.mutate(posts)
    array = []
    posts.each do |post|
      array << {
        id: post.id,
        profile_id: post.profile.id,
        file: post.file,
        url: Rails.application.routes.url_helpers.rails_blob_url(post.file, only_path: true),
        created_at: post.created_at.in_time_zone(post.profile.get_time_zone).iso8601,
      }
    end
    array
  end
end
