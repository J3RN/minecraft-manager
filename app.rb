require 'sinatra/base'
require 'haml'
require 'droplet_kit'
require 'redis'
require 'sidekiq'

# Sidekiq workers
Dir['./workers/*.rb'].sort.each { |f| require f }

class MinecraftManager < Sinatra::Application
  set :kit, DropletKit::Client.new(access_token: ENV["DO_TOKEN"])
  set :redis, Redis.new()

  get '/' do
    current_id = settings.redis.get("minecraft_id") || 0

    begin
      settings.kit.droplets.find(id: current_id)
      state = true
    rescue
      state = false
    end

    haml :index, layout: :main_layout, locals: {on: state}
  end

  post '/update' do
    if params["on"] == "true"
      ::StartWorker.perform_async(settings.redis, settings.kit)
    else
      ::StopWoker.perform_async(settings.redis, settings.kit)
    end
  end
end
