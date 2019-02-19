class PushNotificationJob < ApplicationJob
  queue_as :default

  def perform(profile)

    client = Exponent::Push::Client.new
    # client = Exponent::Push::Client.new(gzip: true)  # for compressed, faster requests

    messages = []

    devices = profile.devices.where.not(push_token: nil)

    if !devices.blank?
      profile.devices.where.not(push_token: nil).each do |device|
        messages << {
          to: device.push_token,
          sound: "default",
          title: "Window Open!",
          # body: "Post in the next 5 min or ",
          body: "",
          ttl: 60*5,
          priority: 'high',
          # data: { url: url }
        }
      end
      
      client.publish messages
    end

  end

end

