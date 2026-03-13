# frozen_string_literal: true

require 'legion/extensions/nomad/helpers/client'

module Legion
  module Extensions
    module Nomad
      module Runners
        module Services
          include Legion::Extensions::Nomad::Helpers::Client

          def list_services(**opts)
            response = connection(**opts).get('/v1/services')
            { result: response.body }
          end

          def get_service(service_name:, **opts)
            response = connection(**opts).get("/v1/service/#{service_name}")
            { result: response.body }
          end

          def delete_service(service_name:, service_id:, **opts)
            response = connection(**opts).delete("/v1/service/#{service_name}/#{service_id}")
            { result: response.status == 200 }
          end

          include Legion::Extensions::Helpers::Lex if Legion::Extensions.const_defined?(:Helpers) &&
                                                      Legion::Extensions::Helpers.const_defined?(:Lex)
        end
      end
    end
  end
end
