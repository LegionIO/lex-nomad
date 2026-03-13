# frozen_string_literal: true

require 'legion/extensions/nomad/helpers/client'

module Legion
  module Extensions
    module Nomad
      module Runners
        module Search
          include Legion::Extensions::Nomad::Helpers::Client

          def prefix_search(prefix:, context: 'all', **opts)
            body = { Prefix: prefix, Context: context }
            response = connection(**opts).post('/v1/search', body)
            { result: response.body }
          end

          def fuzzy_search(text:, context: 'all', **opts)
            body = { Text: text, Context: context }
            response = connection(**opts).post('/v1/search/fuzzy', body)
            { result: response.body }
          end

          include Legion::Extensions::Helpers::Lex if Legion::Extensions.const_defined?(:Helpers) &&
                                                      Legion::Extensions::Helpers.const_defined?(:Lex)
        end
      end
    end
  end
end
