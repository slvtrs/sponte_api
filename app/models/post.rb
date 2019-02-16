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
        url: Rails.application.routes.url_helpers.rails_blob_url(post.file, only_path: true)
      }
    end
    array
  end
end
