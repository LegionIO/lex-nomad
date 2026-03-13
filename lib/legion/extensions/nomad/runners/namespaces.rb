# frozen_string_literal: true

require 'legion/extensions/nomad/helpers/client'

module Legion
  module Extensions
    module Nomad
      module Runners
        module Namespaces
          include Legion::Extensions::Nomad::Helpers::Client

          def list_namespaces(prefix: nil, **)
            params = {}
            params[:prefix] = prefix if prefix
            response = connection(**).get('/v1/namespaces', params)
            { result: response.body }
          end

          def get_namespace(namespace:, **)
            response = connection(**).get("/v1/namespace/#{namespace}")
            { result: response.body }
          end

          def create_or_update_namespace(namespace:, description: nil, **)
            body = { Name: namespace }
            body[:Description] = description if description
            response = connection(**).post("/v1/namespace/#{namespace}", body)
            { result: response.body }
          end

          def delete_namespace(namespace:, **)
            response = connection(**).delete("/v1/namespace/#{namespace}")
            { result: response.body }
          end

          include Legion::Extensions::Helpers::Lex if Legion::Extensions.const_defined?(:Helpers) &&
                                                      Legion::Extensions::Helpers.const_defined?(:Lex)
        end
      end
    end
  end
end
