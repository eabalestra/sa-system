class ClientsController < ApplicationController
  before_action :set_client, only: [:edit, :update, :destroy]

  def index
    @clients = Client.order(name: :asc).paginate(page: params[:page], per_page: 10)
  end

  def new
    @client = Client.new
  end

  def create
    @client = Client.new(client_params)

    respond_to do |format|
      if @client.save
        format.json { head :no_content }
        format.js
      else
        format.json { render json: @client.errors.full_messages, status: :unprocessable_entity }
        format.js { render :new }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @client.update(client_params)
        format.json { head :no_content }
        format.js
      else
        format.json { render json: @client.error.full_messages, status: :unprocessable_entity }
        format.js { render :edit }
      end
    end
  end

  def destroy
    @client.destroy
    respond_to do |format|
      format.js
      format.json { head :no_content }
    end
  end

  def finder
    @results = Client.finder(params[:term]).map do |client|
      {
          id: client.id,
          name: client.name,
      }
    end

    respond_to do |format|
      format.json { render :json => @results }
    end
  end

  private
  def set_client
    @client = Client.find(params[:id])
  end

  def client_params
    params.require(:client).permit(:name, :dir, :phone)
  end
end
