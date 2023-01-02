# frozen_string_literal: true

require 'rails_helper'

RSpec.describe('Api::V1::UsersController', type: :request) do
  describe 'as SuperAdmin User' do
    context 'should be able to manage users' do
      let!(:admin_user) { FactoryBot.create(:user, access_level: :super_admin) }
      let!(:Authorization) { Devise::JWT::TestHelpers.auth_headers({}, admin_user)['Authorization'] }
      include_examples 'Account management'
    end
  end

  describe 'as Admin User' do
    context 'should be able to manage users' do
      let!(:admin_user) { FactoryBot.create(:user, access_level: :admin) }
      let!(:Authorization) { Devise::JWT::TestHelpers.auth_headers({}, admin_user)['Authorization'] }
      include_examples 'Account management'
    end
  end

  describe 'as Default User' do
    describe 'GET /show' do
      pending "see details about myself #{__FILE__}"
    end
  end
end
