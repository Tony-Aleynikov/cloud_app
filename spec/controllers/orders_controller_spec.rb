require 'rails_helper'

RSpec.describe OrdersController, type: :controller do

  describe 'GET #check' do

    it "return status 200 code if checks passed" do
      session[:balance] = 100_000
      session[:login] = "name"
      get :check, params: { os: 'linux', cpu: 4, ram: 8, hdd_type: 'sata', hdd_capacity: 80 }
      expect(response.status).to eq(200)
    end

    it "return status 401 code if there is no balance" do
      get :check, session: { login: "name" }
      expect(response.status).to eq(401)
    end

    it "return status 406 code if configuration not correctd" do
      session[:balance] = 100_000
      session[:login] = "name"
      get :check, params: { os: 'Mac OS', cpu: 4, ram: 8, hdd_type: 'sata', hdd_capacity: 80 } # os - Mac OS
      expect(response.status).to eq(406)
    end

    it "return status 406 code if there is not enough on the balance" do
      session[:balance] = 100
      session[:login] = "name"
      get :check, params: { os: 'linux', cpu: 4, ram: 8, hdd_type: 'sata', hdd_capacity: 80 }
      expect(response.status).to eq(406)
    end

    it 'returns group attributes if checks passed' do
      session[:balance] = 100_000
      session[:login] = "name"
      get :check, params: { os: 'linux', cpu: 4, ram: 8, hdd_type: 'sata', hdd_capacity: 80 }
      expect(JSON.parse(response.body).keys).to contain_exactly('result', 'total', 'balance', 'balance_after_transaction')
    end

    it 'returns group attributes if there is no balance' do
      get :check, session: { login: "name" }
      expect(JSON.parse(response.body).keys).to contain_exactly('result', 'error')
    end

    it 'returns group attributes if configuration not correctd' do
      session[:balance] = 100_000
      session[:login] = "name"
      get :check, params: { os: 'Mac OS', cpu: 4, ram: 8, hdd_type: 'sata', hdd_capacity: 80 } # os - Mac OS
      expect(JSON.parse(response.body).keys).to contain_exactly('result', 'error')
    end

    it 'returns group attributes if there is not enough on the balance' do
      session[:balance] = 100
      session[:login] = "name"
      get :check, params: { os: 'linux', cpu: 4, ram: 8, hdd_type: 'sata', hdd_capacity: 80 }
      expect(JSON.parse(response.body).keys).to contain_exactly('result', 'error')
    end

    it "returns a hash body" do
      session[:balance] = 100_000
      session[:login] = "name"
      get :check, params: { os: 'linux', cpu: 4, ram: 8, hdd_type: 'sata', hdd_capacity: 80 }
      expect(JSON.parse(response.body)).to be_instance_of(Hash)
    end

  end
end
