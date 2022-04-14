class GrapeApi
  module Entities
    class Project < Grape::Entity
      expose :name, documentation: { type: 'String', desc: 'Имя проекта', required: true }
      expose :state, documentation: { type: 'String', desc: 'Статус проекта', required: true }
      expose :created_at, documentation: { type: 'Time', desc: 'Время создания проекта', required: true }
      expose :vms#, documentation: { type: 'Array', desc: 'Характеристики ВМ', required: true }

      def vms
        object.vms.map do |vm|
        {
          id: vm.id,
          name: vm.name,
          configuration: "#{vm.cpu} CPU/#{vm.ram} Gb",
          cost: (vm.cpu * 100 + vm.ram * 10),
          hdds_count: vm.hdds.size
        }
        end
      end

    end
  end
end
