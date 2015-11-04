class MainController < ApplicationController
  def index
    client = DropletKit::Client.new(access_token: ENV["DO_TOKEN"])
    redis = Redis.new()

    current_id = redis.get("minecraft_id") || 0

    begin
      client.droplets.find(id: current_id)
      @on = true
    rescue
      @on = false
    end
  end

  def update
    if permitted_params[:on] == "true"
      StartWorker.perform_async
    else
      StopWorker.perform_async
    end

    render nothing: true
  end

  private

  def permitted_params
    params.permit(:on)
  end
end
