# frozen_string_literal: true

require 'legion/extensions/nomad/helpers/client'

module Legion
  module Extensions
    module Nomad
      module Runners
        module Variables
          include Legion::Extensions::Nomad::Helpers::Client

          def list_variables(prefix: nil, **)
            params = {}
            params[:prefix] = prefix if prefix
            response = connection(**).get('/v1/vars', params)
            { result: response.body }
          end

          def get_variable(path:, **)
            response = connection(**).get("/v1/var/#{path}")
            { result: response.body }
          end

          def create_or_update_variable(path:, items:, **)
            body = { Path: path, Items: items }
            response = connection(**).put("/v1/var/#{path}", body)
            { result: response.body }
          end

          def delete_variable(path:, **)
            response = connection(**).delete("/v1/var/#{path}")
            { result: response.status == 200 }
          end

          include Legion::Extensions::Helpers::Lex if Legion::Extensions.const_defined?(:Helpers) &&
                                                      Legion::Extensions::Helpers.const_defined?(:Lex)
        end
      end
    end
  end
end
