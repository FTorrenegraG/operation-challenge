# frozen_string_literal: true

require 'rails_helper'

RSpec.describe('Api::V2::UserAccounts', type: :request) do
  describe 'GET /index' do
    it 'returns http success' do
      get '/api/v2/user_accounts/index'
      expect(response).to(have_http_status(:success))
    end
  end

  describe 'GET /create' do
    it 'returns http success' do
      get '/api/v2/user_accounts/create'
      expect(response).to(have_http_status(:success))
    end
  end

  describe 'GET /update' do
    it 'returns http success' do
      get '/api/v2/user_accounts/update'
      expect(response).to(have_http_status(:success))
    end
  end
end
