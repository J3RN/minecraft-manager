require 'droplet_kit'
require 'redis'

class StopWorker
  include Sidekiq::Worker

  def perform
    client = DropletKit::Client.new(access_token: ENV["DO_TOKEN"])
    redis = Redis.new

    current_id = redis.get("minecraft_id")

    # Power down the server
    client.droplet_actions.shutdown(droplet_id: current_id)

    # Snapshot the server
    imaged = false
    while not imaged
      begin
        snap_name = "Minecraft - #{Time.now.strftime('%FT%T%z')}"
        snapshot = client.droplet_actions.snapshot(droplet_id: current_id,
                                                         name: snap_name)
        imaged = true
      rescue
        puts "Failed to image. Will try again."
        sleep 30
      end
    end
    redis.set('minecraft_image_id', snapshot.id)

    # Destroy the server
    destroyed = false
    while not destroyed
      begin
        client.droplets.delete(id: current_id)
        destroyed = true
      rescue
        sleep 30
        puts "Failed to destroy. Will try again."
      end
    end
  end
end
