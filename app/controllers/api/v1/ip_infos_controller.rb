class Api::V1::IpInfosController < ApplicationController
  before_action :set_ip, only: [:show, :destroy]

  def show
    render json: { data: @ip }, except: [:id, :created_at, :updated_at], status: :ok
  end

  def create
    #  It wasn't sepcified in the task description, but I assumed that if we try to create an ip which is already in the app's database,
    #  a new geodata will be fetched from the ipstack endpoint and it will replace the old geodata related to that ip.

    render json: { data: {} }, status: :ok
  end

  def destroy
    if @ip.destroy
      render json: { message: 'Destroyed successfully', data: @ip.id }, status: :ok
    else
      render json: { message: @ip.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_ip
    search_param = search_params[:ip].presence || normalized_url_param
    @ip = IpInfo.find_by_ip_or_url(search_param)

    raise ActiveRecord::RecordNotFound unless @ip
  end

  def normalized_url_param
    UrlParser.trim_url(search_params[:url])
  end

  def search_params
    params.permit(:ip, :url)
  end
end
