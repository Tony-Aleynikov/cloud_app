class GrapeApi
  class ProjectsApi < Grape::API
    format :json

    namespace :projects do
      
      desc 'Список Проектов',
        success: GrapeApi::Entities::Project,
        is_array: true

      params do
        optional :state, types: [String, Array[String]]
      end

      get do
        projects = Project.all
        projects = projects.where(state: params[:state]) if params[:state].present?
        # projects = projects.where('state = ?', params[:state]) if params[:state].present?
        present projects, with: GrapeApi::Entities::Project
      end

      post do
        project = Project.new(params)
        if project.save
          status 201
        else
          status 400 #не знаю какой нужен
        end
      end
    
      route_param :id, type: Integer do

        desc 'Просмотр Проекта',
          success: GrapeApi::Entities::Vm,
          failure: [{ code: 404, message: 'Проект не найден' }]
      
        get do
          project = Project.find_by_id(params[:id])
          error!({ message: 'Project не найден' }, 404) unless project
          present project
        end

        delete do
          project = Project.find_by_id(params[:id])
          error!({ message: 'ВМ не найдена' }, 404) unless project
          project.destroy
          status 204
        end

      end

    end
  end
end