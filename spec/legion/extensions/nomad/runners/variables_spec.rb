# frozen_string_literal: true

RSpec.describe Legion::Extensions::Nomad::Runners::Variables do
  let(:client) { Legion::Extensions::Nomad::Client.new(token: 'test-token') }
  let(:stubs) { Faraday::Adapter::Test::Stubs.new }
  let(:test_connection) do
    Faraday.new(url: 'http://127.0.0.1:4646') do |conn|
      conn.request :json
      conn.response :json, content_type: /\bjson$/
      conn.adapter :test, stubs
    end
  end

  before { allow(client).to receive(:connection).and_return(test_connection) }

  describe '#list_variables' do
    it 'returns all variables' do
      stubs.get('/v1/vars') { [200, { 'Content-Type' => 'application/json' }, [{ 'Path' => 'my/var' }]] }
      result = client.list_variables
      expect(result[:result]).to be_an(Array)
    end
  end

  describe '#get_variable' do
    it 'returns a single variable' do
      stubs.get('/v1/var/my/var') { [200, { 'Content-Type' => 'application/json' }, { 'Path' => 'my/var', 'Items' => {} }] }
      result = client.get_variable(path: 'my/var')
      expect(result[:result]['Path']).to eq('my/var')
    end
  end

  describe '#create_or_update_variable' do
    it 'creates a variable' do
      stubs.put('/v1/var/my/var') { [200, { 'Content-Type' => 'application/json' }, { 'Path' => 'my/var' }] }
      result = client.create_or_update_variable(path: 'my/var', items: { key: 'value' })
      expect(result[:result]['Path']).to eq('my/var')
    end
  end

  describe '#delete_variable' do
    it 'deletes a variable' do
      stubs.delete('/v1/var/my/var') { [200, {}, ''] }
      result = client.delete_variable(path: 'my/var')
      expect(result[:result]).to be true
    end
  end
end
