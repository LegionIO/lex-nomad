# frozen_string_literal: true

RSpec.describe Legion::Extensions::Nomad::Runners::Evaluations do
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

  describe '#list_evaluations' do
    it 'returns all evaluations' do
      stubs.get('/v1/evaluations') { [200, { 'Content-Type' => 'application/json' }, [{ 'ID' => 'eval-1' }]] }
      result = client.list_evaluations
      expect(result[:result]).to be_an(Array)
    end
  end

  describe '#get_evaluation' do
    it 'returns a single evaluation' do
      stubs.get('/v1/evaluation/eval-1') { [200, { 'Content-Type' => 'application/json' }, { 'ID' => 'eval-1' }] }
      result = client.get_evaluation(eval_id: 'eval-1')
      expect(result[:result]['ID']).to eq('eval-1')
    end
  end

  describe '#evaluations_count' do
    it 'returns evaluation count' do
      stubs.get('/v1/evaluations/count') { [200, { 'Content-Type' => 'application/json' }, { 'Count' => 42 }] }
      result = client.evaluations_count
      expect(result[:result]['Count']).to eq(42)
    end
  end
end
