# frozen_string_literal: true

RSpec.describe Legion::Extensions::Nomad::Runners::Namespaces do
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

  describe '#list_namespaces' do
    it 'returns all namespaces' do
      stubs.get('/v1/namespaces') { [200, { 'Content-Type' => 'application/json' }, [{ 'Name' => 'default' }]] }
      result = client.list_namespaces
      expect(result[:result]).to be_an(Array)
      expect(result[:result].first['Name']).to eq('default')
    end
  end

  describe '#get_namespace' do
    it 'returns a single namespace' do
      stubs.get('/v1/namespace/default') { [200, { 'Content-Type' => 'application/json' }, { 'Name' => 'default' }] }
      result = client.get_namespace(namespace: 'default')
      expect(result[:result]['Name']).to eq('default')
    end
  end

  describe '#create_or_update_namespace' do
    it 'creates a namespace' do
      stubs.post('/v1/namespace/staging') { [200, { 'Content-Type' => 'application/json' }, {}] }
      result = client.create_or_update_namespace(namespace: 'staging', description: 'Staging env')
      expect(result[:result]).to be_a(Hash)
    end
  end

  describe '#delete_namespace' do
    it 'deletes a namespace' do
      stubs.delete('/v1/namespace/staging') { [200, { 'Content-Type' => 'application/json' }, {}] }
      result = client.delete_namespace(namespace: 'staging')
      expect(result[:result]).to be_a(Hash)
    end
  end
end
