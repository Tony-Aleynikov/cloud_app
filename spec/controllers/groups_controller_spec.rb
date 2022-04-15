require 'rails_helper'

RSpec.describe GroupsController, type: :controller do

  describe 'GET #index' do

    before(:all) do
      create_list(:group, 5)
    end

    after(:all) do
        Group.destroy_all
    end

    it 'returns a 200 status code' do
      get :index
      expect(response.status).to eq(200)
      # expect(response).to have_http_status(200)
    end

    it 'returns an array body' do
      get :index
      expect(JSON.parse(response.body)).to be_instance_of(Array)
    end

    it 'returns group attributes' do
      get :index
      groups = JSON.parse(response.body)
      expect(groups[0].keys).to contain_exactly('id', 'name')
    end

    it 'filter by name' do
      get :index, params: { name: 'group_1' }
      expect(JSON.parse(response.body).count).to eq(1)
    end

    it 'returns content tupe applicaations/returns' do
      get :index
      expect(response.headers["Content-Type"]).to eq("application/json; charset=utf-8")
    end

  end

  describe 'GET #show' do

    before(:each) do
      create(:group, {id: 1,name: 'group_1' } )
    end

    after(:each) do
      Group.destroy_all
    end

    it 'returns a 404 status code if group not found' do
      get :show, params: { id: 0 }
      expect(response.status).to eq(404)
    end

    it 'Если группа есть, то возвращается hash с правильными параметрами' do
      get :show, params: { id: 1 }
      expect(JSON.parse(response.body)).to eq({'id' => 1, 'name' => 'group_1'})
    end

  end
  describe 'POST #create' do

    before(:each) do
      Group.destroy_all
    end

    after(:each) do
      Group.destroy_all
    end

    it 'creates group' do
      post :create, params: { group: { name: 'foo' } }
      expect(Group.first).to have_attributes(name: 'foo')
    end

    it 'returns group attributes' do
     post :create, params: { group: { name: 'foo' } }
     expect(JSON.parse(response.body).keys).to contain_exactly('id', 'name')
    end

  end

  describe 'DELETE #destroy' do

    before(:each) do
      create(:group, id: 1)
    end

    after(:each) do
      Group.destroy_all
    end

    it "returns a 204 status code if group delete" do
      delete :destroy, params: { id: 1 }
      expect(response.status).to eq(204)
    end

    it "empty response.body if group delete" do
      delete :destroy, params: { id: 1 }
      expect(response.body).to eq("")
    end

  end

end
