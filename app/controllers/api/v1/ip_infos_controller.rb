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
    param_ip = ip_search_attributes[:ip]
    @ip = IpInfo.where(ip: param_ip)
                .or(IpInfo.where(url: param_ip)).first

    raise ActiveRecord::RecordNotFound unless @ip
  end

  def ip_search_attributes
    params.permit(:ip)
  end
end
