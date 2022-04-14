require 'rails_helper'

RSpec.describe CreateVmService do
  it 'return error if vm params invalid' do
    allow(CheckVmService).to receive(:call).and_return(false)
    expect(CreateVmService.call).to eq({ error: 'invalid vm params' })
  end

  it 'send notification'
end
