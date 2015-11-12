class Phoenix < ActiveRecord::Base
  has_and_belongs_to_many :users
  belongs_to :owner, class_name: 'User'

  validates_presence_of :name
  validates_presence_of :image_id
  validates_presence_of :ssh_key_id
  validates_presence_of :owner_id

  before_update :update_do_floating_ip, if: :floating_ip_changed?

  def client
    @client ||= DropletKit::Client.new(access_token: self.owner.access_token)
  end

  def ip
    self.floating_ip
  end

  def total_status
    self.status || do_status || "Burnt"
  end

  def do_status
    return unless self.on?

    client.droplets.find(id: self.droplet_id).status
  end

  def on?
    return unless self.droplet_id

    id = self.droplet_id
    if id and client.droplets.all.map {|x| x.id}.include? id
      true
    else
      false
    end
  end

  def active?
    return self.total_status == "active"
  end

  def failed?
    return self.total_status.downcase.include? "fail"
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
    return unless self.on? && self.floating_ip

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

    droplet_name = client.droplets.find(id: self.droplet_id).name
    snap_name = "#{self.name} - #{droplet_name} - #{Time.now.strftime('%FT%T%z')}"
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
