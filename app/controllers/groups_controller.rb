class GroupsController < ApplicationController

    def index
      groups = Group.select(:id,:name)
    if params[:name]
      groups = groups.where(name: params[:name])
    end
      render json: groups
    end

    def show
      group = Group.select(:id, :name).find_by_id(params[:id])
      return head :not_found unless group
      render json: group
    end

    def create
        group = Group.create(group_params)
        render json: { id: group.id, name: group.name }
    end

    private

  def group_params
    params.require(:group).permit(:name)
  end
end
