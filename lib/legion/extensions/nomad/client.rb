# frozen_string_literal: true

require 'legion/extensions/nomad/helpers/client'
require 'legion/extensions/nomad/runners/jobs'
require 'legion/extensions/nomad/runners/nodes'
require 'legion/extensions/nomad/runners/allocations'
require 'legion/extensions/nomad/runners/deployments'
require 'legion/extensions/nomad/runners/evaluations'
require 'legion/extensions/nomad/runners/namespaces'
require 'legion/extensions/nomad/runners/services'
require 'legion/extensions/nomad/runners/variables'
require 'legion/extensions/nomad/runners/status'
require 'legion/extensions/nomad/runners/search'

module Legion
  module Extensions
    module Nomad
      class Client
        include Helpers::Client
        include Runners::Jobs
        include Runners::Nodes
        include Runners::Allocations
        include Runners::Deployments
        include Runners::Evaluations
        include Runners::Namespaces
        include Runners::Services
        include Runners::Variables
        include Runners::Status
        include Runners::Search

        attr_reader :opts

        def initialize(address: 'http://127.0.0.1:4646', token: nil, namespace: nil, **extra)
          @opts = { address: address, token: token, namespace: namespace, **extra }
        end

        def connection(**override)
          super(**@opts.merge(override))
        end
      end
    end
  end
end
