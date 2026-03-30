# frozen_string_literal: true

require 'legion/extensions/nomad/version'
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
require 'legion/extensions/nomad/client'

module Legion
  module Extensions
    module Nomad
      extend Legion::Extensions::Core if Legion::Extensions.const_defined? :Core, false
    end
  end
end
