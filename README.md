# Minecraft Manager

## Rationale

I host my Minecraft server on DigitalOcean, who provides me with reasonable rates. Unfortunately, though, $20/month for a Minecraft server I'm in only every several days seems a bit excessive.

## Solution

Enter Minecraft Manager! What does it do?

### When you move the switch to "on"

- Provisions a new droplet
  - in NYC3 (soon to be configurable)
  - with 2 GB of RAM (soon to be configurable)
  - using a snapshot from the last time your server was active, or an image of your choosing
  - with a configured ssh key (optionally)
  - with a "floating ip" (optionally)

### When you move the switch to "off"

- Powers off the droplet.
- Takes a snapshot of that droplet.
- Destroys the droplet so it stops charging you money.

**As you can probably tell, this is very much a work in progress. Much more to come soon.**

### Stretch goals

- JavaScript polling of an API to live-update the shutdown/startup process.
  - Show details of the "off" and "on" processes such as "powering off the droplet," and "taking a snapshot of the droplet," etc.

## Setup

Before you do anything else, now would be a good time to [generate an access token on DigitalOcean](https://cloud.digitalocean.com/settings/api/tokens).

To get the app set up, simply run:

```bash
$ ./bin/setup
```

This will create two new users with emails "test@example.com" and "test@example.org" and password "testtest" for both. I recommend that you create a new account, as neither of these accounts will have an associated access token.

## Running the server

You'll need to run both the Rails server and Sidekiq simultaneously to get the app to work in it's full capacity.

Start the Rails server:

```bash
bundle exec rails server
```

Start Sidekiq:

```bash
bundle exec sidekiq
```

You should now be able to visit the running application at http://localhost:3000 and create an account with your access token.

Happy Hacking!

## Contributing

- Fork the repository.
- Clone your fork.
- Create a feature branch (e.g. `feature-add-new-thing`, `bugfix-fix-broken-thing`, etc).
- Push your changes up to your fork.
- Send me a pull request.

Please and thank you!
