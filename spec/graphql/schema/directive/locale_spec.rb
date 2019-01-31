# frozen_string_literal: true

require 'rails'
require 'graphql'
require 'graphql-rails-i18n'

describe GraphQL::Schema::Directive::Locale do
  class LocaleSchema < GraphQL::Schema
    class Query < GraphQL::Schema::Object
      field :localized_hello, String, null: false

      def localized_hello
        case I18n.locale
        when :en then 'Hello'
        when :'zh-Hant-HK' then '您好'
        else 'Hello in default language'
        end
      end
    end

    directive(GraphQL::Schema::Directive::Locale)

    query(Query)
    use GraphQL::Execution::Interpreter
  end

  before do
    @original_available_locales = I18n.available_locales
    @original_default_locale = I18n.default_locale

    I18n.available_locales = ['default', 'en', 'zh-Hant-HK']
    I18n.default_locale = 'default'

    GraphQL::Schema::Directive::Locale::LocaleEnum.class_eval do
      locale(codename: 'en', description: 'English')
      locale(codename: 'zh-Hant-HK', description: 'Hong Kong Traditional Chinese')
    end
  end

  after do
    I18n.available_locales = @original_available_locales
    I18n.default_locale = @original_default_locale

    GraphQL::Schema::Directive::Locale::LocaleEnum.instance_variable_set('@own_values', {})
  end

  context 'when @locale directive is not used' do
    it 'does not call I18n.with_locale' do
      str = '{
        result: localizedHello
      }'

      res = LocaleSchema.execute(str)

      expect(I18n).not_to receive(:with_locale)
      expect(res['data']['result']).to eq('Hello in default language')
    end
  end

  context 'when @locale directive is used with en argument' do
    it 'calls I18n.with_locale' do
      expect(I18n).to receive(:with_locale).with('en').once.and_call_original

      str = '{
        result: localizedHello @locale(lang: en)
      }'

      res = LocaleSchema.execute(str)

      expect(res['data']['result']).to eq('Hello')
    end
  end

  context 'when @locale directive is used with zh_hant_hk argument' do
    it 'calls I18n.with_locale' do
      expect(I18n).to receive(:with_locale).with('zh-Hant-HK').once.and_call_original

      str = '{
        result: localizedHello @locale(lang: zh_hant_hk)
      }'

      res = LocaleSchema.execute(str)

      expect(res['data']['result']).to eq('您好')
    end
  end
end
