# frozen_string_literal: true

require 'rails_helper'

RSpec.describe('AccountsController', type: :request) do
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
end
