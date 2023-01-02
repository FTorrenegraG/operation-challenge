# frozen_string_literal: true

require 'swagger_helper'

RSpec.shared_examples('User show me') do
  describe('api/v1/users', type: :request) do
    path '/api/v1/users/show_me' do
      get('show_me user') do
        tags('Api::V1::Users')
        security [Bearer: {}]
        parameter name: :Authorization, in: :header, type: :string
        response(200, 'successful') do
          let(:id) { FactoryBot.create(:user).id }

          run_test!
        end
      end
    end
  end
end
