# frozen_string_literal: true

require 'legion/extensions/nomad/helpers/client'

module Legion
  module Extensions
    module Nomad
      module Runners
        module Deployments
          include Legion::Extensions::Nomad::Helpers::Client

          def list_deployments(prefix: nil, **opts)
            params = {}
            params[:prefix] = prefix if prefix
            response = connection(**opts).get('/v1/deployments', params)
            { result: response.body }
          end

          def get_deployment(deployment_id:, **opts)
            response = connection(**opts).get("/v1/deployment/#{deployment_id}")
            { result: response.body }
          end

          def deployment_allocations(deployment_id:, **opts)
            response = connection(**opts).get("/v1/deployment/allocations/#{deployment_id}")
            { result: response.body }
          end

          def fail_deployment(deployment_id:, **opts)
            response = connection(**opts).post("/v1/deployment/fail/#{deployment_id}")
            { result: response.body }
          end

          def pause_deployment(deployment_id:, pause: true, **opts)
            body = { DeploymentID: deployment_id, Pause: pause }
            response = connection(**opts).post("/v1/deployment/pause/#{deployment_id}", body)
            { result: response.body }
          end

          def promote_deployment(deployment_id:, all: true, groups: nil, **opts)
            body = { DeploymentID: deployment_id, All: all }
            body[:Groups] = groups if groups
            response = connection(**opts).post("/v1/deployment/promote/#{deployment_id}", body)
            { result: response.body }
          end

          def set_allocation_health(deployment_id:, healthy_ids: nil, unhealthy_ids: nil, **opts)
            body = { DeploymentID: deployment_id }
            body[:HealthyAllocationIDs] = healthy_ids if healthy_ids
            body[:UnhealthyAllocationIDs] = unhealthy_ids if unhealthy_ids
            response = connection(**opts).post("/v1/deployment/allocation-health/#{deployment_id}", body)
            { result: response.body }
          end

          def unblock_deployment(deployment_id:, **opts)
            response = connection(**opts).post("/v1/deployment/unblock/#{deployment_id}")
            { result: response.body }
          end

          include Legion::Extensions::Helpers::Lex if Legion::Extensions.const_defined?(:Helpers) &&
                                                      Legion::Extensions::Helpers.const_defined?(:Lex)
        end
      end
    end
  end
end
