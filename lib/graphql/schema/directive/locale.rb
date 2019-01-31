# frozen_string_literal: true

class GraphQL::Schema::Directive::Locale < GraphQL::Schema::Directive
  class LocaleEnum < GraphQL::Schema::Enum
    def self.locale(codename:, description: '')
      value(codename.underscore, description: description, value: codename)
    end
  end

  locations GraphQL::Schema::Directive::FIELD

  attr_accessor :locale_enum

  argument :lang, type: LocaleEnum, required: false

  def self.resolve(object, argument, context)
    I18n.with_locale(argument[:lang]) do
      yield
    end
  end
end
