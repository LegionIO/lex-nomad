# frozen_string_literal: true

RSpec.describe Legion::Extensions::Nomad::Runners::Status do
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

  describe '#leader' do
    it 'returns the cluster leader' do
      stubs.get('/v1/status/leader') { [200, { 'Content-Type' => 'application/json' }, '"10.0.0.1:4647"'] }
      result = client.leader
      expect(result[:result]).to eq('10.0.0.1:4647')
    end
  end

  describe '#peers' do
    it 'returns the raft peers' do
      stubs.get('/v1/status/peers') { [200, { 'Content-Type' => 'application/json' }, ['10.0.0.1:4647', '10.0.0.2:4647']] }
      result = client.peers
      expect(result[:result]).to be_an(Array)
      expect(result[:result].length).to eq(2)
    end
  end
end
