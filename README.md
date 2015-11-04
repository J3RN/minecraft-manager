# Minecraft Manager

## Rationale

I host my Minecraft server on DigitalOcean, who provides me with reasonable rates. Unfortunately, though, $20/month for a Minecraft server I'm in only every several days seems a bit excessive.

## Solution

Enter Minecraft Manager. What does it do?

### When you move the switch to "on"

- Provisions a new droplet with ssh key (hopefully you've got one) in NYC 3, with 2 GB of RAM. Oh, and using the last image of a server you provisioned with MM, or a pre-set value.
  - TODO: Check if you actually have SSH keys
- Updates your first floating IP to point to this new server.
  - TODO: Make sure you have a floating IP first
  - TODO: Have you set the floating IP if you want this to happen

### When you move the switch to "off"

- Powers off the last droplet you powered on with the manager.
- Takes a snapshot of that droplet and records it's ID to use for the next droplet.
- Destroys the droplet so it stops charging you money.

TODO: Better documentation

**As you can probably tell, this is very much a work in progress, and does not currently work very much. Much more to come soon.**

### Stretch goals

- WebSockets to live-update the shutdown/startup process

## Contributing

Fork it, send me a pull request. Please and thank you.
