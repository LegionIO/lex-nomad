# frozen_string_literal: true

RSpec.describe Legion::Extensions::Nomad::Runners::Deployments do
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

  describe '#list_deployments' do
    it 'returns all deployments' do
      stubs.get('/v1/deployments') { [200, { 'Content-Type' => 'application/json' }, [{ 'ID' => 'deploy-1' }]] }
      result = client.list_deployments
      expect(result[:result]).to be_an(Array)
    end
  end

  describe '#get_deployment' do
    it 'returns a single deployment' do
      stubs.get('/v1/deployment/deploy-1') { [200, { 'Content-Type' => 'application/json' }, { 'ID' => 'deploy-1' }] }
      result = client.get_deployment(deployment_id: 'deploy-1')
      expect(result[:result]['ID']).to eq('deploy-1')
    end
  end

  describe '#fail_deployment' do
    it 'marks a deployment as failed' do
      stubs.post('/v1/deployment/fail/deploy-1') do
        [200, { 'Content-Type' => 'application/json' }, { 'EvalID' => 'eval-1' }]
      end
      result = client.fail_deployment(deployment_id: 'deploy-1')
      expect(result[:result]['EvalID']).to eq('eval-1')
    end
  end

  describe '#promote_deployment' do
    it 'promotes canary deployment' do
      stubs.post('/v1/deployment/promote/deploy-1') do
        [200, { 'Content-Type' => 'application/json' }, { 'EvalID' => 'eval-2' }]
      end
      result = client.promote_deployment(deployment_id: 'deploy-1')
      expect(result[:result]['EvalID']).to eq('eval-2')
    end
  end

  describe '#pause_deployment' do
    it 'pauses a deployment' do
      stubs.post('/v1/deployment/pause/deploy-1') do
        [200, { 'Content-Type' => 'application/json' }, { 'EvalID' => 'eval-3' }]
      end
      result = client.pause_deployment(deployment_id: 'deploy-1', pause: true)
      expect(result[:result]['EvalID']).to eq('eval-3')
    end
  end
end
