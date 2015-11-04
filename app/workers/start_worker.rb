class StartWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform
    client = DropletKit::Client.new(access_token: ENV["DO_TOKEN"])
    redis = Redis.new

    # Fetch the image from Redis
    image_id = redis.get('minecraft_image_id')
    floating_ip = redis.get('minecraft_floating_ip')

    # Fetch the SSH key from DO
    # TODO: Have you set your SSH key
    ssh_key = client.ssh_keys.all.first.id

    # Create new droplet
    droplet = DropletKit::Droplet.new(name: SecureRandom.hex(10),
                                      region: "nyc3",
                                      image: image_id,
                                      size: '2gb',
                                      ssh_keys: [ssh_key])
    created = client.droplets.create(droplet)

    # Update Redis
    redis.set('minecraft_id', created.id)

    # Wait for create to finish
    while client.droplets.find(id: created.id).status != "active"
      sleep 30
    end

    # Update Floating IP
    client.floating_ip_actions.assign(ip: floating_ip, droplet_id: created.id)
  end
end
