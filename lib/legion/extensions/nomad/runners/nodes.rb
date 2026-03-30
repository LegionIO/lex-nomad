# frozen_string_literal: true

require 'legion/extensions/nomad/helpers/client'

module Legion
  module Extensions
    module Nomad
      module Runners
        module Nodes
          include Legion::Extensions::Nomad::Helpers::Client

          def list_nodes(prefix: nil, **)
            params = {}
            params[:prefix] = prefix if prefix
            response = connection(**).get('/v1/nodes', params)
            { result: response.body }
          end

          def get_node(node_id:, **)
            response = connection(**).get("/v1/node/#{node_id}")
            { result: response.body }
          end

          def node_allocations(node_id:, **)
            response = connection(**).get("/v1/node/#{node_id}/allocations")
            { result: response.body }
          end

          def evaluate_node(node_id:, **)
            response = connection(**).post("/v1/node/#{node_id}/evaluate")
            { result: response.body }
          end

          def drain_node(node_id:, enable: true, deadline: nil, ignore_system_jobs: false, **)
            drain_spec = nil
            drain_spec = { Deadline: deadline || 0, IgnoreSystemJobs: ignore_system_jobs } if enable
            body = { DrainSpec: drain_spec, NodeID: node_id }
            response = connection(**).post("/v1/node/#{node_id}/drain", body)
            { result: response.body }
          end

          def purge_node(node_id:, **)
            response = connection(**).post("/v1/node/#{node_id}/purge")
            { result: response.body }
          end

          def set_node_eligibility(node_id:, eligible: true, **)
            eligibility = eligible ? 'eligible' : 'ineligible'
            body = { NodeID: node_id, Eligibility: eligibility }
            response = connection(**).post("/v1/node/#{node_id}/eligibility", body)
            { result: response.body }
          end

          include Legion::Extensions::Helpers::Lex if Legion::Extensions.const_defined?(:Helpers, false) &&
                                                      Legion::Extensions::Helpers.const_defined?(:Lex, false)
        end
      end
    end
  end
end
