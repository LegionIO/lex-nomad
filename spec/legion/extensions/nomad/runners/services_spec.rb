# frozen_string_literal: true

RSpec.describe Legion::Extensions::Nomad::Runners::Services do
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

  describe '#list_services' do
    it 'returns all services' do
      stubs.get('/v1/services') { [200, { 'Content-Type' => 'application/json' }, [{ 'Namespace' => 'default' }]] }
      result = client.list_services
      expect(result[:result]).to be_an(Array)
    end
  end

  describe '#get_service' do
    it 'returns a single service' do
      stubs.get('/v1/service/web') { [200, { 'Content-Type' => 'application/json' }, [{ 'ServiceName' => 'web' }]] }
      result = client.get_service(service_name: 'web')
      expect(result[:result]).to be_an(Array)
    end
  end

  describe '#delete_service' do
    it 'deletes a service registration' do
      stubs.delete('/v1/service/web/svc-123') { [200, {}, ''] }
      result = client.delete_service(service_name: 'web', service_id: 'svc-123')
      expect(result[:result]).to be true
    end
  end
end
