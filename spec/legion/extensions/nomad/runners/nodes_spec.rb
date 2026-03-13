# frozen_string_literal: true

RSpec.describe Legion::Extensions::Nomad::Runners::Nodes do
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

  describe '#list_nodes' do
    it 'returns all nodes' do
      stubs.get('/v1/nodes') { [200, { 'Content-Type' => 'application/json' }, [{ 'ID' => 'node-1' }]] }
      result = client.list_nodes
      expect(result[:result]).to be_an(Array)
      expect(result[:result].first['ID']).to eq('node-1')
    end
  end

  describe '#get_node' do
    it 'returns a single node' do
      stubs.get('/v1/node/node-1') { [200, { 'Content-Type' => 'application/json' }, { 'ID' => 'node-1' }] }
      result = client.get_node(node_id: 'node-1')
      expect(result[:result]['ID']).to eq('node-1')
    end
  end

  describe '#node_allocations' do
    it 'returns allocations for a node' do
      stubs.get('/v1/node/node-1/allocations') { [200, { 'Content-Type' => 'application/json' }, [{ 'ID' => 'alloc-1' }]] }
      result = client.node_allocations(node_id: 'node-1')
      expect(result[:result]).to be_an(Array)
    end
  end

  describe '#drain_node' do
    it 'enables drain on a node' do
      stubs.post('/v1/node/node-1/drain') { [200, { 'Content-Type' => 'application/json' }, { 'EvalIDs' => ['eval-1'] }] }
      result = client.drain_node(node_id: 'node-1')
      expect(result[:result]['EvalIDs']).to be_an(Array)
    end
  end

  describe '#set_node_eligibility' do
    it 'sets node eligibility' do
      stubs.post('/v1/node/node-1/eligibility') { [200, { 'Content-Type' => 'application/json' }, { 'EvalIDs' => [] }] }
      result = client.set_node_eligibility(node_id: 'node-1', eligible: false)
      expect(result[:result]).to have_key('EvalIDs')
    end
  end
end
