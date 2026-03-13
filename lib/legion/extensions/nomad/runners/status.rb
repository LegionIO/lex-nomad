# frozen_string_literal: true

require 'legion/extensions/nomad/helpers/client'

module Legion
  module Extensions
    module Nomad
      module Runners
        module Status
          include Legion::Extensions::Nomad::Helpers::Client

          def leader(**opts)
            response = connection(**opts).get('/v1/status/leader')
            { result: response.body }
          end

          def peers(**opts)
            response = connection(**opts).get('/v1/status/peers')
            { result: response.body }
          end

          include Legion::Extensions::Helpers::Lex if Legion::Extensions.const_defined?(:Helpers) &&
                                                      Legion::Extensions::Helpers.const_defined?(:Lex)
        end
      end
    end
  end
end
