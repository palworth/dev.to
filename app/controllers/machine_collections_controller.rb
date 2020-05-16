class MachineCollectionsController < ApplicationController

  before_action :authenticate_user!, except: %i[feed new]

  def index
    @machine_collections = logged_in_user.machine_collections
  end

  def show
    @machine_collection = logged_in_user.machine_collections.find(params[:id])
  end

  def new
  end

  def create
    user = User.find_by(id: logged_in_user.id)
    coll = user.machine_collections.create({title: params[:title], tag_list: params[:tag_list]})
    if coll.save
      coll.articles << coll.suggested_articles
      redirect_to "/machinecollections/#{coll.id}"
    else
      flash[:error] = 'Collection not created. Please complete the required fields.'
      redirect_to "/machinecollections/new"
    end
    require "pry"; binding.pry
  end

private

  def machine_collection_params
    params.permit(:title, :user_id, :tag_list)
  end

  def logged_in_user
    current_user
  end

end
