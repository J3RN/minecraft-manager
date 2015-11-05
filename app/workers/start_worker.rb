class StartWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(phoenix_id)
    phoenix = Phoenix.find(phoenix_id)
    return if phoenix.on?

    # Set being brought up status
    phoenix.update!(status: "Being born")

    # Create new droplet
    phoenix.create_droplet!

    # Wait for create to finish
    while phoenix.do_status != "active"
      sleep 30
    end

    # Update the floating IP on DigitalOcean
    phoenix.update_do_floating_ip

    # Defer to DO for status
    phoenix.update!(status: nil)
  rescue Exception => e
    puts "Start failed"
    puts e.message
    puts e.backtrace.inspect

    phoenix.update!(status: "Failed to be born")
  end
end
