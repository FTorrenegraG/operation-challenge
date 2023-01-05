# frozen_string_literal: true

require 'swagger_helper'

RSpec.shared_examples('Account management') do
  describe('api/v1/accounts', type: :request) do
    path '/api/v1/accounts' do
      get('list accounts') do
        tags('Api::V1::Accounts')
        security [Bearer: {}]
        parameter name: :Authorization, in: :header, type: :string
        response(200, 'successful') do
          run_test!
        end
      end

      post('create account') do
        tags('Api::V1::Accounts')
        consumes('application/json')
        produces('application/json')
        security [Bearer: {}]
        parameter name: :Authorization, in: :header, type: :string
        parameter name: :account_params, in: :body, schema: {
          type: :object,
          properties: {
            account: {
              type: :object,
              properties: {
                name: { type: :string },
                client_name: { type: :string },
                manager_name: { type: :string }
              },
              required: %w[name]
            }
          },
          required: %w[account]
        }

        response '201', 'account created' do
          let(:account_params) { { account: { name: 'foo' } } }
          run_test!
        end

        response '422', 'invalid request' do
          let(:account) { FactoryBot.create(:account) }
          let(:account_params) { { account: { name: account.name } } }
          run_test!
        end
      end
    end

    path '/api/v1/accounts/{id}' do
      # You'll want to customize the parameter types...
      parameter name: 'id', in: :path, type: :string, description: 'id'

      get('show account') do
        tags('Api::V1::Accounts')
        consumes('application/json')
        produces('application/json')
        security [Bearer: {}]
        parameter name: :Authorization, in: :header, type: :string
        response(200, 'successful') do
          let(:id) { FactoryBot.create(:account).id }

          run_test!
        end
        response '404', 'not found' do
          let(:id) { '123' }
          run_test!
        end
      end

      patch('update account') do
        tags('Api::V1::Accounts')
        consumes('application/json')
        produces('application/json')
        security [Bearer: {}]
        parameter name: :Authorization, in: :header, type: :string
        parameter name: :account_params, in: :body, schema: {
          type: :object,
          properties: {
            account: {
              type: :object,
              properties: {
                name: { type: :string },
                client_name: { type: :string },
                manager_name: { type: :string }
              },
              required: %w[name]
            }
          },
          required: %w[account]
        }

        response '200', 'account updated' do
          let(:id) { FactoryBot.create(:account).id }
          let(:account_params) { { account: { name: 'foo' } } }
          run_test!
        end

        response '422', 'invalid request' do
          let(:account) { FactoryBot.create(:account, name: 'foo') }
          let(:id) { FactoryBot.create(:account, name: 'foo2').id }
          let(:account_params) { { account: { name: account.name } } }
          run_test!
        end
        response '404', 'not found' do
          let(:id) { '123' }
          let(:account_params) { { account: { name: 'foo' } } }
          run_test!
        end
      end

      put('update account') do
        tags('Api::V1::Accounts')
        consumes('application/json')
        produces('application/json')
        security [Bearer: {}]
        parameter name: :Authorization, in: :header, type: :string
        parameter name: :account_params, in: :body, schema: {
          type: :object,
          properties: {
            account: {
              type: :object,
              properties: {
                name: { type: :string },
                client_name: { type: :string },
                manager_name: { type: :string }
              },
              required: %w[name]
            }
          },
          required: %w[account]
        }

        response '200', 'account updated' do
          let(:id) { FactoryBot.create(:account).id }
          let(:account_params) { { account: { name: 'foo' } } }
          run_test!
        end

        response '404', 'not found' do
          let(:id) { '123' }
          let(:account_params) { { account: { name: 'foo' } } }
          run_test!
        end

        response '422', 'invalid request' do
          let(:account) { FactoryBot.create(:account, name: 'foo') }
          let(:id) { FactoryBot.create(:account, name: 'foo2').id }
          let(:account_params) { { account: { name: account.name } } }
          run_test!
        end
      end

      delete('delete account') do
        tags('Api::V1::Accounts')
        security [Bearer: {}]
        parameter name: :Authorization, in: :header, type: :string
        response(200, 'successful') do
          let(:id) { FactoryBot.create(:account, name: 'foo2').id }

          run_test!
        end
        response '404', 'not found' do
          let(:id) { '123' }
          run_test!
        end
      end
    end
  end
end
