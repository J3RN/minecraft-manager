class PhoenixesController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_access_token!, only: [:new]
  before_action :set_phoenix, only: [:edit, :update, :destroy]
  before_action :ensure_ownership!, only: [:edit, :destroy]
  before_action :set_extras, only: [:new, :edit]

  def index
    @phoenixes = current_user.phoenixes.order(:created_at)
  end

  def new
    @phoenix = Phoenix.new
  end

  def edit
  end

  def create
    @phoenix = Phoenix.new(phoenix_params)
    # Set current user as the owner and add them as a collaborator
    @phoenix.owner = current_user
    @phoenix.users << current_user

    if @phoenix.save
      redirect_to phoenixes_url, notice: 'Phoenix was successfully created.'
    else
      set_extras
      render :new
    end
  end

  def update
    if phoenix_params.has_key?(:on)
      if phoenix_params[:on] == "true"
        @phoenix.update!(status: "Waiting to be born")

        StartWorker.perform_async(@phoenix.id)
      else
        @phoenix.update!(status: "Waiting to die")

        StopWorker.perform_async(@phoenix.id)
      end

      redirect_to phoenixes_url
    else
      # Add owner to the users list
      p_params = phoenix_params.tap do |x|
        x["user_ids"] << @phoenix.owner_id
      end

      if @phoenix.update(p_params)
        redirect_to phoenixes_url, notice: 'Phoenix was successfully updated.'
      else
        render :edit
      end
    end
  end

  def destroy
    @phoenix.destroy
    redirect_to phoenixes_url, notice: 'Phoenix was successfully destroyed.'
  end

  private
    def set_phoenix
      @phoenix = Phoenix.find(params[:id])
    end

    def set_extras
      owner_id = @phoenix.try(:owner_id) || current_user.id
      @users = User.where.not(id: owner_id).map { |x| [x.username, x.id] }

      client = DropletKit::Client.new(access_token: current_user.access_token)

      @droplets = client.droplets.all.to_a.map { |x| [x.name, x.id] }
      @images = client.images.all
                      .sort_by(&:name)
                      .reverse
                      .sort_by(&:distribution)
                      .map do |x|
        ["#{x.distribution} #{x.name}", x.id]
      end
      @floating_ips = client.floating_ips.all.to_a.map { |x| x.ip }
      @ssh_keys = client.ssh_keys.all.to_a.map { |x| [x.name, x.id] }
    end

    def ensure_access_token!
      return if current_user.access_token.present?

      redirect_to phoenixes_url, alert: 'You need to add an access token to create phoenixes!'
    end

    def ensure_ownership!
      return if current_user == @phoenix.owner

      redirect_to phoenixes_url, alert: 'You can only edit phoenixes you own!'
    end

    def phoenix_params
      params.require(:phoenix).permit(:droplet_id, :image_id, :floating_ip,
                                      :name, :ssh_key_id, :on, user_ids: [])
    end
end
