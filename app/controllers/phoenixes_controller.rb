class PhoenixesController < ApplicationController
  before_action :set_phoenix, only: [:edit, :update, :destroy]
  before_action :set_user, only: [:index, :create]  # TODO: Also change this

  def index
    @phoenixes = @user.phoenixes.all
  end

  def new
    @phoenix = Phoenix.new
  end

  def edit
  end

  def create
    @phoenix = Phoenix.new(phoenix_params)
    @phoenix.user = @user

    if @phoenix.save
      redirect_to @phoenix, notice: 'Phoenix was successfully created.'
    else
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
      if @phoenix.update(phoenix_params)
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

    def set_user
      @user = User.first      # TODO: Change this bad, bad code
    end

    def phoenix_params
      params.require(:phoenix).permit(:droplet_id, :image_id, :floating_ip, :name, :ssh_key_id, :on)
    end
end
