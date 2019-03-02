class PushNotificationJob < ApplicationJob
  queue_as :default

  def perform(profile)

    client = Exponent::Push::Client.new
    # client = Exponent::Push::Client.new(gzip: true)  # for compressed, faster requests

    messages = []

    devices = profile.devices.where.not(push_token: nil)

    window_duration = 60 * 3

    if !devices.blank?
      profile.devices.where.not(push_token: nil).each do |device|
        messages << {
          to: device.push_token,
          sound: "default",
          title: "Window Open!",
          # body: "Post in the next 5 min or ",
          body: "",
          ttl: window_duration,
          priority: 'high',
          data: { 
            window_open_at: profile.last_window_at.iso8601, 
            window_close_at: (profile.last_window_at + window_duration.seconds).iso8601,
          }
        }
      end
      
      client.publish messages
    end

  end

end

