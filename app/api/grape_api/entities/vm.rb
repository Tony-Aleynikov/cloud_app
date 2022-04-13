class GrapeApi
  module Entities
    class Vm < Grape::Entity
      expose :id, documentation: { type: 'Integer', desc: 'Идентификатор ВМ', required: true }
      expose :configuration, documentation: { type: 'String', desc: 'Конфигурация', required: true }
      expose :cost, if: lambda { |object, options| options[:detail] == true }, documentation: { type: 'Integer', desc: 'Стоимость', required: false }
  
      def configuration
        "#{object.cpu} CPU/#{object.ram} Gb"
      end

      def cost
        object.cpu * 100 + object.ram * 10
      end
    end
  end
end