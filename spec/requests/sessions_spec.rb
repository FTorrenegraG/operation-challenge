# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe('sessions', type: :request) do
  path '/login' do
    post('Create Session') do
      tags('Sessions')
      consumes('application/json')
      produces('application/json')
      parameter name: :user_params, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              email: { type: :string },
              password: { type: :string }
            },
            required: %w[email password]
          }
        },
        required: %w[user]
      }

      response '200', 'session created' do
        let(:user) { FactoryBot.create(:user) }
        let(:user_params) { { user: { email: user.email, password: 'password' } } }
        run_test!
      end

      response '401', 'invalid request' do
        let(:user) { FactoryBot.create(:user) }
        let(:user_params) { { email: user.email, password: 'wrong_password' } }
        run_test!
      end
    end
  end

  path '/logout' do
    delete('delete session') do
      tags('Sessions')
      consumes('application/json')
      produces('application/json')
      security [Bearer: {}]
      parameter name: :Authorization, in: :header, type: :string

      response '204', 'session revoked' do
        run_test!
      end
    end
  end
end
