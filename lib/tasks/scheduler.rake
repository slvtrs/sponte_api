desc "This task is called by the Heroku scheduler add-on"

# task :update_feed => :environment do
#   puts "Updating feed..."
#   NewsFeed.update
#   puts "done."
# end

task :schedule_todays_notifications => :environment do
  puts 'push notif from scheduler'
  Profile.all.each do |profile|

    time_zone = profile.get_time_zone
    now = Time.now.in_time_zone(time_zone)

    # apply at user's local midnight
    if now.hour == 12

      start_at = now.change({hour: profile.window_start_at})
      end_at = now.change({hour: profile.window_end_at})
      
      if profile.invert_window
        notify_at = Time.at((now.end_of_day.to_f - now.beginning_of_day.to_f)*rand + now.beginning_of_day.to_f)
        if notify_at.hour >= end_at.hour || notify_at.hour < start_at.hour
          # this is good
        else
          if notify_at.hour < 12
            notify_at = notify_at + 12.hours
          else
            notify_at = notify_at - 12.hours
          end
        end
        notify_at = Time.at((end_at.to_f - start_at.to_f)*rand + start_at.to_f)
      else
        notify_at = Time.at((end_at.to_f - start_at.to_f)*rand + start_at.to_f)
      end

      profile.update_attributes!(next_window_at: notify_at)

    end
  end
end

task :send_push_notifications => :environment do
  puts 'push notif from scheduler'
  Profile.all.each do |profile|

    time_zone = profile.get_time_zone
    now = Time.now.in_time_zone(time_zone)

    # ensure they haven't already been notified today
    start_of_today = now.beginning_of_day
    start_of_last_window_day = (profile.last_window_at.present? ?
      profile.last_window_at.in_time_zone(time_zone).beginning_of_day :
      start_of_today - 1.day)
    already_notified_today = start_of_last_window_day == start_of_today
    if !already_notified_today

      min_away = (now - profile.next_window_at).to_i.abs / 60
      if min_away < 10
        profile.update_attributes!(last_window_at: Time.now)
        PushNotificationJob.perform_now(profile)
      end

      # ensure we are currently within their window
      # if profile.window_start_at && profile.window_start_at
      #   current_hour = now.hour.to_i
      #   if ( profile.invert_window &&
      #     current_hour >= profile.window_end_at.to_i ||
      #     current_hour < profile.window_start_at.to_i
      #   ) || ( !profile.invert_window &&
      #     current_hour >= profile.window_start_at.to_i && 
      #     current_hour < profile.window_end_at.to_i
      #   )
              # 
      #   end
      # end

    end
  end
end