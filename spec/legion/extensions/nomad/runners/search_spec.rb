# frozen_string_literal: true

RSpec.describe Legion::Extensions::Nomad::Runners::Search do
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

  describe '#prefix_search' do
    it 'returns prefix matches' do
      stubs.post('/v1/search') do
        [200, { 'Content-Type' => 'application/json' }, { 'Matches' => { 'jobs' => ['example'] } }]
      end
      result = client.prefix_search(prefix: 'exam')
      expect(result[:result]['Matches']).to have_key('jobs')
    end
  end

  describe '#fuzzy_search' do
    it 'returns fuzzy matches' do
      stubs.post('/v1/search/fuzzy') do
        [200, { 'Content-Type' => 'application/json' }, { 'Matches' => { 'jobs' => [{ 'ID' => 'example' }] } }]
      end
      result = client.fuzzy_search(text: 'exam')
      expect(result[:result]['Matches']).to have_key('jobs')
    end
  end
end
