class PushNotificationJob < ApplicationJob
  queue_as :default

  def perform(profile)

    client = Exponent::Push::Client.new
    # client = Exponent::Push::Client.new(gzip: true)  # for compressed, faster requests

    messages = []
    profile.devices.where.not(token: nil).each do |device|
      messages << {
        to: "ExponentPushToken[#{device.token}]",
        sound: "default",
        body: "Time to post!"
      }
    end
    client.publish messages
    return

    messages = [{
      to: "ExponentPushToken[xxxxxxxxxxxxxxxxxxxxxx]",
      sound: "default",
      body: "Hello world!"
    }, {
      to: "ExponentPushToken[yyyyyyyyyyyyyyyyyyyyyy]",
      badge: 1,
      body: "You've got mail"
    }]

    client.publish messages


    url = ''
    title = ''
    body = ''
    sound = 'default'
    priority = 0

    # puts 'PUSH NOTIFICATION'
    # puts url
    # puts title
    # puts body
    
    ios_devices = user.devices.where(device_type: 'ios').where.not(device_id: nil)
    android_devices = user.devices.where(device_type: 'android').where.not(device_id: nil)

    unless ios_devices.empty?
      notifs = []
      registration_ids = ios_devices.distinct.pluck(:device_id)
      registration_ids.each do |device_token|
        notifs << APNS::Notification.new(
          device_token, 
          alert: {
            title: title,
            body: body
          }, 
          badge: user.chat_sessions.where(active: true, category: 'general').sum(:user_unreads),
          sound: sound,
          other: { url: url }
        )
      end
      APNS.send_notifications(notifs)
    end

    unless android_devices.empty?
      fcm = FCM.new(ENV['FCM_SERVER_KEY'])
      registration_ids = android_devices.distinct.pluck(:device_id)
      options = { 
        notification: {
          title: title, 
          body: body, 
          sound: sound.split('.')[0]
        },
        data: { url: url }
        # collapse_key: "chat_#{chat.id}"
      }
      response = fcm.send(registration_ids, options)
    end

  end

end

