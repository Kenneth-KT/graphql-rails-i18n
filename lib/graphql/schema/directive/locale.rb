# frozen_string_literal: true

module GraphQL
  class Schema
    class Directive
      class Locale < GraphQL::Schema::Directive
        class LocaleEnum < GraphQL::Schema::Enum
          def self.locale(codename:, description: '')
            value(codename.underscore, description: description, value: codename)
          end
        end

        locations GraphQL::Schema::Directive::FIELD

        attr_accessor :locale_enum

        argument :lang, type: LocaleEnum, required: false

        def self.resolve(_object, argument, _context)
          I18n.with_locale(argument[:lang]) do
            yield
          end
        end
      end
    end
  end
end
