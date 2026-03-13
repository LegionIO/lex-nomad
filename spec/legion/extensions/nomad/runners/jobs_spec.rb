# frozen_string_literal: true

RSpec.describe Legion::Extensions::Nomad::Runners::Jobs do
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

  describe '#list_jobs' do
    it 'returns all jobs' do
      stubs.get('/v1/jobs') { [200, { 'Content-Type' => 'application/json' }, [{ 'ID' => 'example' }]] }
      result = client.list_jobs
      expect(result[:result]).to be_an(Array)
      expect(result[:result].first['ID']).to eq('example')
    end
  end

  describe '#get_job' do
    it 'returns a single job' do
      stubs.get('/v1/job/example') { [200, { 'Content-Type' => 'application/json' }, { 'ID' => 'example' }] }
      result = client.get_job(job_id: 'example')
      expect(result[:result]['ID']).to eq('example')
    end
  end

  describe '#create_job' do
    it 'registers a new job' do
      stubs.post('/v1/jobs') { [200, { 'Content-Type' => 'application/json' }, { 'EvalID' => 'abc-123' }] }
      result = client.create_job(job: { ID: 'example', Type: 'service' })
      expect(result[:result]['EvalID']).to eq('abc-123')
    end
  end

  describe '#delete_job' do
    it 'deregisters a job' do
      stubs.delete('/v1/job/example') { [200, { 'Content-Type' => 'application/json' }, { 'EvalID' => 'abc-456' }] }
      result = client.delete_job(job_id: 'example')
      expect(result[:result]['EvalID']).to eq('abc-456')
    end
  end

  describe '#job_summary' do
    it 'returns job summary' do
      stubs.get('/v1/job/example/summary') { [200, { 'Content-Type' => 'application/json' }, { 'JobID' => 'example' }] }
      result = client.job_summary(job_id: 'example')
      expect(result[:result]['JobID']).to eq('example')
    end
  end

  describe '#plan_job' do
    it 'performs a dry-run plan' do
      stubs.post('/v1/job/example/plan') { [200, { 'Content-Type' => 'application/json' }, { 'Diff' => {} }] }
      result = client.plan_job(job_id: 'example', job: { ID: 'example' })
      expect(result[:result]).to have_key('Diff')
    end
  end

  describe '#parse_job' do
    it 'parses HCL to JSON' do
      stubs.post('/v1/jobs/parse') { [200, { 'Content-Type' => 'application/json' }, { 'ID' => 'parsed' }] }
      result = client.parse_job(hcl: 'job "example" {}')
      expect(result[:result]['ID']).to eq('parsed')
    end
  end

  describe '#job_versions' do
    it 'lists job versions' do
      stubs.get('/v1/job/example/versions') do
        [200, { 'Content-Type' => 'application/json' }, { 'Versions' => [{ 'Version' => 0 }] }]
      end
      result = client.job_versions(job_id: 'example')
      expect(result[:result]['Versions']).to be_an(Array)
    end
  end

  describe '#scale_job' do
    it 'scales a task group' do
      stubs.post('/v1/job/example/scale') { [200, { 'Content-Type' => 'application/json' }, { 'EvalID' => 'scale-1' }] }
      result = client.scale_job(job_id: 'example', group: 'web', count: 5)
      expect(result[:result]['EvalID']).to eq('scale-1')
    end
  end
end
