# frozen_string_literal: true

require 'rails_helper'

RSpec.describe('Api::V1::Accounts', type: :request) do
  describe 'GET /create' do
    it 'returns http success' do
      get '/api/v1/accounts/create'
      expect(response).to(have_http_status(:success))
    end
  end

  describe 'GET /index' do
    it 'returns http success' do
      get '/api/v1/accounts/index'
      expect(response).to(have_http_status(:success))
    end
  end

  describe 'GET /show' do
    it 'returns http success' do
      get '/api/v1/accounts/show'
      expect(response).to(have_http_status(:success))
    end
  end

  describe 'GET /update' do
    it 'returns http success' do
      get '/api/v1/accounts/update'
      expect(response).to(have_http_status(:success))
    end
  end

  describe 'GET /destroy' do
    it 'returns http success' do
      get '/api/v1/accounts/destroy'
      expect(response).to(have_http_status(:success))
    end
  end
end
