# frozen_string_literal: true

require 'legion/extensions/nomad/helpers/client'

module Legion
  module Extensions
    module Nomad
      module Runners
        module Evaluations
          include Legion::Extensions::Nomad::Helpers::Client

          def list_evaluations(prefix: nil, **opts)
            params = {}
            params[:prefix] = prefix if prefix
            response = connection(**opts).get('/v1/evaluations', params)
            { result: response.body }
          end

          def get_evaluation(eval_id:, **opts)
            response = connection(**opts).get("/v1/evaluation/#{eval_id}")
            { result: response.body }
          end

          def evaluation_allocations(eval_id:, **opts)
            response = connection(**opts).get("/v1/evaluation/#{eval_id}/allocations")
            { result: response.body }
          end

          def evaluations_count(**opts)
            response = connection(**opts).get('/v1/evaluations/count')
            { result: response.body }
          end

          def delete_evaluations(eval_ids:, **opts)
            response = connection(**opts).delete('/v1/evaluations', { EvalIDs: eval_ids })
            { result: response.body }
          end

          include Legion::Extensions::Helpers::Lex if Legion::Extensions.const_defined?(:Helpers) &&
                                                      Legion::Extensions::Helpers.const_defined?(:Lex)
        end
      end
    end
  end
end
