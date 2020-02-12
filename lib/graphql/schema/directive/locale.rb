# frozen_string_literal: true

module GraphQL
  class Schema
    class Directive
      class Locale < GraphQL::Schema::Directive
        locations(
          GraphQL::Schema::Directive::FIELD
        )

        argument :lang, String, required: false

        def self.resolve(_object, argument, _context)
          I18n.with_locale(argument[:lang]) do
            yield
          end
        end
      end
    end
  end
end
