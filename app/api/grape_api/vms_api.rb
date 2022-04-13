class GrapeApi
    class VmsApi < Grape::API
      format :json
  
    namespace :vms do

      desc 'Список ВМ',
        success: GrapeApi::Entities::Vm,
        is_array: true

      params do
        optional :cpu, type: Integer
      end

      get do
        vms = Vm.all
        vms = vms.where('cpu >= :cpu', cpu: params[:cpu]) if params[:cpu].present?
        present vms, with: GrapeApi::Entities::Vm
      end
      

      route_param :id, type: Integer do

        desc 'Просмотр ВМ',
          success: GrapeApi::Entities::Vm,
          failure: [{ code: 404, message: 'ВМ не найдена' }]

        params do
          optional :detail, type: Boolean
        end

        get do
          vm = Vm.find_by_id(params[:id])
          error!({ message: 'ВМ не найдена' }, 404) unless vm
          present vm, with: GrapeApi::Entities::Vm, detail: params[:detail]
        end

        delete do
          vm = Vm.find_by_id(params[:id])
          error!({ message: 'ВМ не найдена' }, 404) unless vm
          vm.destroy
          status 204
        end

      end

    end
  end
end
  