desc "This task is called by the Heroku scheduler add-on"

# task :update_feed => :environment do
#   puts "Updating feed..."
#   NewsFeed.update
#   puts "done."
# end

task :send_push_notifications => :environment do
  Profile.all.each do |profile|
    if profile.window_start_at && profile.window_start_at
      time_zone = profile.get_timezone
      current_hour = Time.now.in_time_zone(time_zone).hour
      if (
        current_hour > profile.window_start_at && 
        current_hour < profile.window_end_at
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