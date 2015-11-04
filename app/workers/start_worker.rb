class StartWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform
    client = DropletKit::Client.new(access_token: ENV["DO_TOKEN"])
    redis = Redis.new

    # Fetch the image from Redis
    image_id = redis.get('minecraft_image_id')

    # Fetch the SSH key from DO
    ssh_key = client.ssh_keys.all.first.id

    # Create new droplet
    droplet = DropletKit::Droplet.new(name: SecureRandom.hex(10),
                                      region: "nyc3",
                                      image: image_id,
                                      size: '2gb',
                                      ssh_keys: [ssh_key])
    created = client.droplets.create(droplet)

    # # Update Floating IP
    # ip = client.floating_ips.all.first.ip
    # client.floating_ip_actions.assign(ip: ip, droplet_id: created.id)

    # # Update Redis
    # redis.set('minecraft_id', created.id)
  end
end
