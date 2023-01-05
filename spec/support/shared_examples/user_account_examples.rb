# frozen_string_literal: true

RSpec.shared_examples('UserAccount Management') do
  describe('api/v2/user_accounts', type: :request) do
    path '/api/v2/user_accounts' do
      get('list user_accounts') do
        tags('Api::V2::UserAccounts')
        security [Bearer: {}]
        parameter name: :Authorization, in: :header, type: :string
        parameter name: :search_params, in: :path, schema: {
          type: :object,
          properties: {
            users: {
              type: :object,
              properties: {
                name: { type: :string },
                email: { type: :string }
              }
            },
            accounts: {
              type: :object,
              properties: {
                name: { type: :string },
                client_name: { type: :string }
              }
            },
            in_date: { type: :string },
            out_date: { type: :string }
          }
        }
        response(200, 'successful') do
          run_test!
        end
      end

      post('create user_accounts') do
        tags('Api::V2::UserAccounts')
        consumes('application/json')
        produces('application/json')
        security [Bearer: {}]
        parameter name: :Authorization, in: :header, type: :string
        parameter name: :user_account_params, in: :body, schema: {
          type: :object,
          properties: {
            user_id: { type: :string },
            account_id: { type: :string },
            in_date: { type: :string },
            out_date: { type: :string }
          },
          required: %w[user_id account_id]
        }

        response '201', 'user account created' do
          let(:user_id) { FactoryBot.create(:user).id.to_s }
          let(:account_id) { FactoryBot.create(:account).id.to_s }
          let(:user_account_params) { { user_id:, account_id: } }
          run_test!
        end

        response '404', 'not found' do
          let(:user_account_params) { { user_id: '132', account_id: '123' } }
          run_test!
        end

        response '422', 'invalid request' do
          let(:user_account) { FactoryBot.create(:user_account) }
          let(:user_account_params) { { user_id: user_account.user_id.to_s, account_id: user_account.account_id.to_s } }
          run_test!
        end
      end
    end

    path '/api/v2/user_accounts/{id}' do
      # You'll want to customize the parameter types...
      parameter name: 'id', in: :path, type: :string, description: 'id'

      patch('update user_account') do
        tags('Api::V2::UserAccounts')
        consumes('application/json')
        produces('application/json')
        security [Bearer: {}]
        parameter name: :Authorization, in: :header, type: :string
        parameter name: :user_account_params, in: :body, schema: {
          type: :object,
          properties: {
            in_date: { type: :string },
            out_date: { type: :string }
          }
        }

        response '200', 'account updated' do
          let(:id) { FactoryBot.create(:user_account).id }
          let(:user_account_params) { { in_date: (Time.now + 1.day).to_datetime } }
          run_test!
        end

        response '422', 'invalid request' do
          let(:id) { FactoryBot.create(:user_account).id }
          let(:user_account_params) { { out_date: (Time.now - 1.day).to_datetime } }
          run_test!
        end
        response '404', 'not found' do
          let(:id) { '123' }
          let(:user_account_params) { { out_date: (Time.now - 1.day).to_datetime } }
          run_test!
        end
      end

      put('update user_accounts') do
        tags('Api::V2::UserAccounts')
        consumes('application/json')
        produces('application/json')
        security [Bearer: {}]
        parameter name: :Authorization, in: :header, type: :string
        parameter name: :user_account_params, in: :body, schema: {
          type: :object,
          properties: {
            in_date: { type: :string },
            out_date: { type: :string }
          }
        }

        response '200', 'account updated' do
          let(:id) { FactoryBot.create(:user_account).id }
          let(:user_account_params) { { in_date: (Time.now + 1.day).to_datetime } }
          run_test!
        end

        response '422', 'invalid request' do
          let(:id) { FactoryBot.create(:user_account).id }
          let(:user_account_params) { { out_date: (Time.now - 1.day).to_datetime } }
          run_test!
        end
        response '404', 'not found' do
          let(:id) { '123' }
          let(:user_account_params) { { in_date: (Time.now + 1.day).to_datetime } }
          run_test!
        end
      end

      delete('delete user_accounts') do
        tags('Api::V2::UserAccounts')
        security [Bearer: {}]
        parameter name: :Authorization, in: :header, type: :string
        response(200, 'successful') do
          let(:id) { FactoryBot.create(:user_account).id }

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
