require 'rails_helper'

RSpec.describe "MovementsControllers", type: :request do
  describe 'as SuperAdmin User' do
    context 'should be able to see movements' do
      include_examples 'Movements'
    end
  end

  describe 'as Admin User' do
    context 'should be able to see movements' do
      include_examples 'Movements'
    end
  end
end
