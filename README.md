# GraphQL Rails i18n

Ruby on Rails i18n integration plugin for [graphql-ruby](https://github.com/rmosolgo/graphql-ruby), inspired by [graphql-i18n npm library](https://github.com/Canner/graphql-i18n).

## Installation

Install from RubyGems by adding it to your `Gemfile`, then bundling.

```ruby
# Gemfile
gem 'graphql-rails-i18n'
```

```
$ bundle install
```

## Getting Started

follow the `### Step` comments below to setup your schema with locale directive

```ruby
class ExampleSchema < GraphQL::Schema

  ### Step 1: Use new interpreter runtime from graphql-ruby
  use GraphQL::Execution::Interpreter

  ### Step 2: Declare locale directive in your schema
  directive GraphQL::Schema::Directive::Locale

  GraphQL::Schema::Directive::Locale::LocaleEnum.class_eval do
    ### Step 3: Tell @locale directive which languages are supported.
    ###         Language code names are automagically added into LocaleEnum and
    ###         underscored using `underscore` method.
    ###         For instance: `zh-Hant-HK` will be transformed into `zh_hant_hk`.
    locale(codename: 'en', description: 'English')
    locale(codename: 'zh-Hant-HK', description: 'Hong Kong Traditional Chinese')
  end

  # In your Query root object
  class Query < GraphQL::Schema::Object
    field :localized_hello, String, null: false

    def localized_hello
      ### Step 4: Deliver actual content data based on selected language
      ###         ** Code below is for demostration only, you may hook up some
      ###         i18n gems like `globalize` to output localized content.
      case I18n.locale
      when :en then 'Hello'
      when :'zh-Hant-HK' then '您好'
      else 'Hello in default language'
      end
    end
  end

  query Query
end
```

You can start making queries with locale directive.

```GraphQL
query {
  ### Step 5: Write your query with @locale directive.
  ###         Remember language code names are transformed automatically to underscore format.
  defaultString: localizedString
  englishString: localizedString @locale(lang: en)
  chineseString: localizedString @locale(lang: zh_hant_hk)
}
```
will output

```json
{
  "defaultString": "Hello in default language",
  "englishString": "Hello",
  "chineseString": "您好"
}
```
