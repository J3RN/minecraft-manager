# Minecraft Manager

## Rationale

I host my Minecraft server on DigitalOcean, who provides me with reasonable rates. Unfortunately, though, $20/month for a Minecraft server I'm in only every several days seems a bit excessive.

## Solution

Enter Minecraft Manager. What does it do?

### When you move the switch to "on"

- Provisions a new droplet with ssh key (optionally), in NYC 3, with 2 GB of RAM. Oh, and using the last image of a server you provisioned with MM, or a pre-set image ID.
- Updates your first floating IP to point to this new server, if you've set one

### When you move the switch to "off"

- Powers off the last droplet you powered on with the manager.
- Takes a snapshot of that droplet and records it's ID to use for the next droplet.
- Destroys the droplet so it stops charging you money.

**As you can probably tell, this is very much a work in progress. Much more to come soon.**

### Stretch goals

- WebSockets to live-update the shutdown/startup process

## Setup

To get the app set up, simply run:

```bash
$ ./bin/setup
```

Unfortunately, there is no interface currently for adding new users. So, to get your user set up, you'll have to open a Rails console and do that manually.

## Running the server

You'll need to run both the rails server and Sidekiq simultaneously to get the app to work in it's full capacity.

Start the rails server:

```bash
bundle exec rails server
```

Start Sidekiq

```bash
bundle exec sidekiq
```

## Contributing

Fork it, send me a pull request. Please and thank you.
