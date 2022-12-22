require 'rails_helper'

RSpec.describe "UsersController", type: :request do
  describe 'as SuperAdmin User' do
    context 'should be able to manage users' do
      include_examples 'Account management'
    end
  end

  describe 'as Admin User' do
    context 'should be able to manage users' do
      include_examples 'Account management'
    end
  end

  describe 'as Default User' do
    describe "GET /show" do
      pending "see details about myself #{__FILE__}"
    end
  end
end
