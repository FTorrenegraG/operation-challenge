require 'rails_helper'
require 'jwt'

RSpec.feature "SessionsController", type: :request do
  describe "Authentication User" do
    let!(:user) { create(:user) }
    let!(:user_params) { { user: { email: user.email, password: 'password' } } }
    let!(:headers) { { Accept: 'application/json' } }
    let(:jwt_token){ response.headers['Authorization'].split(' ')[1] }
    let(:jwt_payload) { JWT.decode(jwt_token, nil, false)[0] }
    
    context "the user should be able to login" do
      before do
        post '/login', params: user_params, headers: headers
      end
      it 'return 200' do
        expect(response.status).to eq(200)
      end
      it 'return JWT token in authorization header' do
        expect(response.headers['Authorization']).to be_present
      end
      it 'return user id in jwt token' do
        expect(jwt_payload['sub']).to eq(user.id.to_s)
      end
      it 'return use class in jwt token' do
        expect(jwt_payload['scp']).to eq('user')
      end
      it 'return jti in jwt token' do
        expect(jwt_payload['jti']).to eq(user.jti)
      end
    end

    context "the user should not be able to login" do
      before do
        post '/login', params: { user: { email: user.email, password: 'wrong_password' } }, headers: headers
      end
      it 'return 401' do
        expect(response.status).to eq(401)
      end
      it 'return JWT token in authorization header' do
        expect(response.headers['Authorization']).not_to be_present
      end
    end

    context "the user should be able to logout" do
      before do
        post '/login', params: user_params
      end
      it 'return nothing' do
        headers = { Authentication: "Bearer #{jwt_token}" }
        delete '/logout', headers: headers
        expect(response.status).to eq(204)
      end
    end
  end
end
