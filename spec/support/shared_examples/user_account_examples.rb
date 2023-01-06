# frozen_string_literal: true

RSpec.shared_examples('UserAccount Management') do
  describe('api/v2/user_accounts', type: :request) do
    path '/api/v2/user_accounts' do
      get('list user_accounts') do
        tags('Api::V2::UserAccounts')
        security [Bearer: {}]
        parameter name: :Authorization, in: :header, type: :string
        parameter name: :search_params, in: :query, schema: {
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
        let!(:user_accounts) { FactoryBot.create_list(:user_account, 5) }
        response(200, 'successful') do
          context 'search by users' do
            context 'specific user is search by name' do
              let(:user_account) { user_accounts.sample }
              let(:search_params) { { users: { name: user_account.user.name } } }
              before do |example|
                submit_request(example.metadata)
              end
              it 'should return only the user searched' do
                data = JSON.parse(response.body).map { |u_a_i| u_a_i['id'] }
                other_user_account = UserAccount.unscoped.eager_load(:user).where.not(users: { name: user_account.user.name }).sample.id
                expect(data).to(include(user_account.id))
                expect(data).not_to(include(other_user_account))
              end
            end

            context 'specific user is search by email' do
              let(:user_account) { user_accounts.sample }
              let(:search_params) { { users: { email: user_account.user.email } } }
              before do |example|
                submit_request(example.metadata)
              end
              it 'should return only the user searched' do
                data = JSON.parse(response.body).map { |u_a_i| u_a_i['id'] }
                other_user_account = UserAccount.unscoped.eager_load(:user).where.not(users: { email: user_account.user.email }).sample.id
                expect(data).to(include(user_account.id))
                expect(data).not_to(include(other_user_account))
              end
            end
          end

          context 'search by accounts' do
            context 'specific account is search by name' do
              let(:user_account) { user_accounts.sample }
              let(:search_params) { { accounts: { name: user_account.account.name } } }
              before do |example|
                submit_request(example.metadata)
              end
              it 'should return only the user searched' do
                data = JSON.parse(response.body).map { |u_a_i| u_a_i['id'] }
                other_user_account = UserAccount.unscoped.eager_load(:account).where.not(accounts: { name: user_account.account.name }).sample.id
                expect(data).to(include(user_account.id))
                expect(data).not_to(include(other_user_account))
              end
            end

            context 'specific account is search by client_name' do
              let(:user_account) { user_accounts.sample }
              let(:search_params) { { accounts: { client_name: user_account.account.client_name } } }
              before do |example|
                submit_request(example.metadata)
              end
              it 'should return only the user searched' do
                data = JSON.parse(response.body).map { |u_a_i| u_a_i['id'] }
                other_user_account = UserAccount.unscoped.eager_load(:account).where.not(accounts: { client_name: user_account.account.client_name }).sample.id
                expect(data).to(include(user_account.id))
                expect(data).not_to(include(other_user_account))
              end
            end
          end
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
