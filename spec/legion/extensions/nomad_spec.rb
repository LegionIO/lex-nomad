# frozen_string_literal: true

RSpec.describe Legion::Extensions::Nomad do
  it 'has a version number' do
    expect(Legion::Extensions::Nomad::VERSION).not_to be_nil
  end

  it 'defines the Client class' do
    expect(Legion::Extensions::Nomad::Client).to be_a(Class)
  end
end
