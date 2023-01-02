# frozen_string_literal: true

require 'rails_helper'

RSpec.describe('Api::V1::UsersController', type: :request) do
  describe 'as SuperAdmin User' do
    context 'should be able to manage users' do
      let!(:admin_user) { FactoryBot.create(:user, access_level: :super_admin) }
      let!(:Authorization) { Devise::JWT::TestHelpers.auth_headers({}, admin_user)['Authorization'] }
      include_examples 'User management'
      include_examples 'User show me'
    end
  end

  describe 'as Admin User' do
    context 'should be able to manage users' do
      let!(:admin_user) { FactoryBot.create(:user, access_level: :admin) }
      let!(:Authorization) { Devise::JWT::TestHelpers.auth_headers({}, admin_user)['Authorization'] }
      include_examples 'User management'
      include_examples 'User show me'
    end
  end

  describe 'as Default User' do
    describe 'GET /show_me' do
      let!(:admin_user) { FactoryBot.create(:user) }
      let!(:Authorization) { Devise::JWT::TestHelpers.auth_headers({}, admin_user)['Authorization'] }
      include_examples 'User show me'
    end
  end
end
