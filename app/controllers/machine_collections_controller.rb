class MachineCollectionsController < ApplicationController

  before_action :authenticate_user!, except: %i[feed new]

  def index
    machine_collections = current_user.machine_collections
    render json: MachineCollectionSerializer.new(machine_collections)
  end

  def show
    machine_collection = current_user.machine_collections.find(params[:id])
    render json: MachineCollectionSerializer.new(machine_collection)
  end

private
  def machine_collection_params
    allowed_params = %i[title user_id tag_list]
    params.require(:machine_collections).permit(allowed_params)
  end
end
