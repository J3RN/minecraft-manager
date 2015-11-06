class Phoenix < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :image_id
  validates_presence_of :floating_ip
  validates_presence_of :name
  validates_presence_of :user_id

  before_update :update_do_floating_ip, if: :floating_ip_changed?

  def client
    @client ||= DropletKit::Client.new(access_token: self.user.access_token)
  end

  def ip
    self.floating_ip
  end

  def total_status
    self.status || do_status || "Burnt"
  end

  def do_status
    return unless self.droplet_id.present?
    return unless self.on?

    client.droplets.find(id: self.droplet_id).status
  end

  def on?
    id = self.droplet_id

    if id and client.droplets.all.map {|x| x.id}.include? id
      true
    else
      false
    end
  end

  def create_droplet!
    droplet = DropletKit::Droplet.new(name: SecureRandom.hex(10),
                                      region: "nyc3",
                                      image: self.image_id,
                                      size: '2gb',
                                      ssh_keys: [self.ssh_key_id])
    created = client.droplets.create(droplet)
    self.update!(droplet_id: created.id)
  end

  def update_do_floating_ip
    return unless self.on?
    client.floating_ip_actions.assign(droplet_id: self.droplet_id,
                                      ip: self.floating_ip)
  end

  def action_status(action_id)
    client.droplet_actions.find(id: action_id).status
  end

  def shutdown
    return unless self.on?
    return if self.do_status == "off"

    client.droplet_actions.shutdown(droplet_id: self.droplet_id)
  end

  def snapshot
    return unless self.on?

    snap_name = "#{self.name} - #{Time.now.strftime('%FT%T%z')}"
    client.droplet_actions.snapshot(droplet_id: self.droplet_id,
                                    name: snap_name)
  end

  def snapshot_ids
    return unless self.on?
    client.droplets.find(id: self.droplet_id).snapshot_ids
  end

  def burn!
    return unless self.on?
    client.droplets.delete(id: self.droplet_id)
  end
end
