# frozen_string_literal: true

require 'legion/extensions/nomad/helpers/client'

module Legion
  module Extensions
    module Nomad
      module Runners
        module Allocations
          include Legion::Extensions::Nomad::Helpers::Client

          def list_allocations(prefix: nil, **opts)
            params = {}
            params[:prefix] = prefix if prefix
            response = connection(**opts).get('/v1/allocations', params)
            { result: response.body }
          end

          def get_allocation(alloc_id:, **opts)
            response = connection(**opts).get("/v1/allocation/#{alloc_id}")
            { result: response.body }
          end

          def stop_allocation(alloc_id:, **opts)
            response = connection(**opts).post("/v1/allocation/#{alloc_id}/stop")
            { result: response.body }
          end

          def signal_allocation(alloc_id:, signal: 'SIGTERM', task: nil, **opts)
            body = { Signal: signal }
            body[:Task] = task if task
            response = connection(**opts).post("/v1/client/allocation/#{alloc_id}/signal", body)
            { result: response.body }
          end

          def restart_allocation(alloc_id:, task: nil, all_tasks: false, **opts)
            body = { AllTasks: all_tasks }
            body[:TaskName] = task if task
            response = connection(**opts).post("/v1/client/allocation/#{alloc_id}/restart", body)
            { result: response.body }
          end

          def allocation_services(alloc_id:, **opts)
            response = connection(**opts).get("/v1/allocation/#{alloc_id}/services")
            { result: response.body }
          end

          def allocation_checks(alloc_id:, **opts)
            response = connection(**opts).get("/v1/allocation/#{alloc_id}/checks")
            { result: response.body }
          end

          include Legion::Extensions::Helpers::Lex if Legion::Extensions.const_defined?(:Helpers) &&
                                                      Legion::Extensions::Helpers.const_defined?(:Lex)
        end
      end
    end
  end
end
