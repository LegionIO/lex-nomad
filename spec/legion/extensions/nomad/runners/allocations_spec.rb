# frozen_string_literal: true

RSpec.describe Legion::Extensions::Nomad::Runners::Allocations do
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

  describe '#list_allocations' do
    it 'returns all allocations' do
      stubs.get('/v1/allocations') { [200, { 'Content-Type' => 'application/json' }, [{ 'ID' => 'alloc-1' }]] }
      result = client.list_allocations
      expect(result[:result]).to be_an(Array)
    end
  end

  describe '#get_allocation' do
    it 'returns a single allocation' do
      stubs.get('/v1/allocation/alloc-1') { [200, { 'Content-Type' => 'application/json' }, { 'ID' => 'alloc-1' }] }
      result = client.get_allocation(alloc_id: 'alloc-1')
      expect(result[:result]['ID']).to eq('alloc-1')
    end
  end

  describe '#stop_allocation' do
    it 'stops an allocation' do
      stubs.post('/v1/allocation/alloc-1/stop') { [200, { 'Content-Type' => 'application/json' }, { 'EvalID' => 'eval-1' }] }
      result = client.stop_allocation(alloc_id: 'alloc-1')
      expect(result[:result]['EvalID']).to eq('eval-1')
    end
  end

  describe '#signal_allocation' do
    it 'signals an allocation' do
      stubs.post('/v1/client/allocation/alloc-1/signal') { [200, { 'Content-Type' => 'application/json' }, {}] }
      result = client.signal_allocation(alloc_id: 'alloc-1', signal: 'SIGHUP')
      expect(result[:result]).to be_a(Hash)
    end
  end

  describe '#restart_allocation' do
    it 'restarts an allocation' do
      stubs.post('/v1/client/allocation/alloc-1/restart') { [200, { 'Content-Type' => 'application/json' }, {}] }
      result = client.restart_allocation(alloc_id: 'alloc-1')
      expect(result[:result]).to be_a(Hash)
    end
  end
end
