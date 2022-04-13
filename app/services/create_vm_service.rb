class CreateVmService
    def self.call
      result = CheckVmService.call
      return { error: 'invalid vm params' } unless result
      NotifierService.call
    end
end