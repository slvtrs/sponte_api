desc "This task is called by the Heroku scheduler add-on"

# task :update_feed => :environment do
#   puts "Updating feed..."
#   NewsFeed.update
#   puts "done."
# end

task :send_push_notifications => :environment do
  puts 'push notif from scheduler'
  Profile.all.each do |profile|
    if profile.window_start_at && profile.window_start_at
      time_zone = profile.get_time_zone
      current_hour = Time.now.in_time_zone(time_zone).hour.to_i
      if (
        current_hour > profile.window_start_at.to_i && 
        current_hour < profile.window_end_at.to_i
      )
        # if profile.last_notified_at
          PushNotificationJob.perform_now(profile)
          # send_at = random_time
          # PushNotificationJob.set(wait_until: send_at).perform_later(profile)
        # end
      end
    end
  end
end