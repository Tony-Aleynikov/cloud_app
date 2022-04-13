class VmsController < ApplicationController
    def index
        @vms = Vm.first(10)
        render json: { vms: @vms }
    end
end
