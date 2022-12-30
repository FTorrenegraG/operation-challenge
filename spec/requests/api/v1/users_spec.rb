# frozen_string_literal: true

require 'swagger_helper'
require 'devise/jwt/test_helpers'
require 'faker'

RSpec.describe('api/v1/users', type: :request) do
  let!(:admin_user) { FactoryBot.create(:user, access_level: :admin) }
  let!(:Authorization) { Devise::JWT::TestHelpers.auth_headers({}, admin_user)['Authorization'] }

  path '/api/v1/users' do
    get('list users') do
      tags('Api::V1::Users')
      security [Bearer: {}]
      parameter name: :Authorization, in: :header, type: :string
      response(200, 'successful') do
        run_test!
      end
    end

    post('create user') do
      tags('Api::V1::Users')
      consumes('application/json')
      produces('application/json')
      security [Bearer: {}]
      parameter name: :Authorization, in: :header, type: :string
      parameter name: :user_params, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              email: { type: :string },
              password: { type: :string },
              password_confirmation: { type: :string },
              english_level: { type: :string },
              knowledge: { type: :string },
              cv_url: { type: :string },
              access_level: { type: :string, enum: %i[standart admin] }
            },
            required: %w[email password]
          }
        },
        required: %w[user]
      }

      response '201', 'user created' do
        let(:user_params) { { user: { email: Faker::Internet.safe_email, password: 'password' } } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:user) { FactoryBot.create(:user) }
        let(:user_params) { { email: user.email, password: 'password' } }
        run_test!
      end

      response '401', 'Unauthorized' do
        let(:user_params) { { email: Faker::Internet.safe_email, password: 'password', access_level: :admin } }
        run_test!
      end
    end
  end

  path '/api/v1/users/{id}' do
    # You'll want to customize the parameter types...
    parameter name: 'id', in: :path, type: :string, description: 'id'

    get('show user') do
      tags('Api::V1::Users')
      security [Bearer: {}]
      parameter name: :Authorization, in: :header, type: :string
      response(200, 'successful') do
        let(:id) { FactoryBot.create(:user).id }

        run_test!
      end
      response '404', 'not found' do
        let(:id) { '123' }
        run_test!
      end
    end

    patch('update user') do
      tags('Api::V1::Users')
      consumes('application/json')
      produces('application/json')
      security [Bearer: {}]
      parameter name: :Authorization, in: :header, type: :string
      parameter name: :user_params, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              email: { type: :string },
              password: { type: :string },
              password_confirmation: { type: :string },
              english_level: { type: :string },
              knowledge: { type: :string },
              cv_url: { type: :string },
              access_level: { type: :string, enum: %i[standart admin] }
            },
            required: %w[email password]
          }
        },
        required: %w[user]
      }

      response '200', 'user updated' do
        let(:id) { FactoryBot.create(:user).id }
        let(:user_params) { { user: { email: Faker::Internet.safe_email, password: 'password' } } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:user) { FactoryBot.create(:user) }
        let(:id) { FactoryBot.create(:user).id }
        let(:user_params) { { email: user.email, password: 'password' } }
        run_test!
      end

      response '401', 'Unauthorized' do
        let(:id) { FactoryBot.create(:user).id }
        let(:user_params) { { email: Faker::Internet.safe_email, password: 'password', access_level: :admin } }
        run_test!
      end

      response '404', 'not found' do
        let(:id) { '123' }
        let(:user_params) { { email: Faker::Internet.safe_email, password: 'password', access_level: :admin } }
        run_test!
      end
    end

    put('update user') do
      tags('Api::V1::Users')
      consumes('application/json')
      produces('application/json')
      security [Bearer: {}]
      parameter name: :Authorization, in: :header, type: :string
      parameter name: :user_params, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              email: { type: :string },
              password: { type: :string },
              password_confirmation: { type: :string },
              english_level: { type: :string },
              knowledge: { type: :string },
              cv_url: { type: :string },
              access_level: { type: :string, enum: %i[standart admin] }
            },
            required: %w[email password]
          }
        },
        required: %w[user]
      }

      response '200', 'user updated' do
        let(:id) { FactoryBot.create(:user).id }
        let(:user_params) { { user: { email: Faker::Internet.safe_email, password: 'password' } } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:user) { FactoryBot.create(:user) }
        let(:id) { FactoryBot.create(:user).id }
        let(:user_params) { { email: user.email, password: 'password' } }
        run_test!
      end

      response '401', 'Unauthorized' do
        let(:id) { FactoryBot.create(:user).id }
        let(:user_params) { { email: Faker::Internet.safe_email, password: 'password', access_level: :admin } }
        run_test!
      end

      response '404', 'not found' do
        let(:id) { '123' }
        let(:user_params) { { email: Faker::Internet.safe_email, password: 'password', access_level: :admin } }
        run_test!
      end
    end

    delete('delete user') do
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
