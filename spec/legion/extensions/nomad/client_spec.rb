# frozen_string_literal: true

RSpec.describe Legion::Extensions::Nomad::Client do
  subject(:client) { described_class.new(token: 'test-token') }

  it 'stores configuration' do
    expect(client.opts[:token]).to eq('test-token')
    expect(client.opts[:address]).to eq('http://127.0.0.1:4646')
  end

  it 'accepts a custom address' do
    custom = described_class.new(token: 'tok', address: 'http://nomad.example.com:4646')
    expect(custom.opts[:address]).to eq('http://nomad.example.com:4646')
  end

  it 'accepts a namespace' do
    ns_client = described_class.new(token: 'tok', namespace: 'production')
    expect(ns_client.opts[:namespace]).to eq('production')
  end

  it 'returns a Faraday connection' do
    expect(client.connection).to be_a(Faraday::Connection)
  end
end
