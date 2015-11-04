class StopWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def wait_for_action(client, action_id)
    while client.droplet_actions.find(id: action_id).status != "completed"
      sleep 30
    end
  end

  def perform
    client = DropletKit::Client.new(access_token: ENV["DO_TOKEN"])
    redis = Redis.new

    current_id = redis.get("minecraft_id")

    if client.droplets.find(id: current_id).status != "off"
      # Power down the server
      shutdown_action = client.droplet_actions.shutdown(droplet_id: current_id)

      # Wait for the shutdown to complete
      wait_for_action(client, shutdown_action.id)
    end

    # Snapshot the server
    snap_name = "Minecraft - #{Time.now.strftime('%FT%T%z')}"
    snapshot_action = client.droplet_actions.snapshot(droplet_id: current_id,
                                                      name: snap_name)

    # Wait for the snapshot to finish
    wait_for_action(client, snapshot_action.id)

    # Record image ID
    snapshot_id = client.droplets.find(id: current_id).snapshot_ids.last
    redis.set('minecraft_image_id', snapshot_id)

    # Destroy the server
    client.droplets.delete(id: current_id)
  end
end
