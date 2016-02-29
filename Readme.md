# text_hyphen_rails

This is a Rails/ActiveRecord-wrapper for the [text-hyphen](https://github.com/halostatue/text-hyphen) package.

## Installation

In your `Gemfile`:
```ruby
gem 'text_hyphen_rails'
```
 Then `bundle install`.

## Usage

 Say you have a model Post with a text-attribute `#content`
 ```ruby
 class Post < ActiveRecord::Base
   text_hyphen :content
 end
```

`text_hyphen :content` adds a `content_hyph`-method to your model that returns the hyphenated value of `content` (e.g. `@post.content_hyph`).

## Settings

You can specify a number of settings globally or per method(s).

```ruby
  # in an initializer
  TextHyphenRails.configure do |cnf|
    cnf.lang :de1
  end

  # per method
  text_hyphen :content, lang: :en_uk, hyphen: '&shy;'
  text_hyphen :another_att, lang: :de1
```
The follwing options are available:

| name            |    default                | description                                                                     |
|-----------------|:-------------------------:|---------------------------------------------------------------------------------|
| hyphen          | "\u00ad"                  | the hyphen                                                                      |
| lang            | :en_uk                    | the identifier of the language, one of: `:ca :cs :da :de1 :de2 :en_uk :en_us :es :et :eu :fi :fr :ga :hr :hsb :hu1 :hu2 :ia :id :is :it :la :mn :nl :no1 :no2 :pl :pt :ru :sv` |
| lang_att        | nil                       | name of an attribute (method or column) that returns a language-identifier      |
| word_regex      | /[[:alpha:]]{4,}/m        | how to find words    |
| left / right    | 2 / 2                     | I'm not sure     |
| prefix / suffix | nil / :hyph               | prefix / suffix for the created mathods     |
| replace_meth    | false                     | replace the original method (or attribute-getter?) with the hyphenated one |


### `lang_att`
Make the language setting be derived from an attribute in your model.

```ruby
  text_hyphen :content, lang_att: :lang
```

If you had existing data where the language is named more conventionally in the `lang`-column:

```ruby
  text_hyphen :content, lang_att: :lang_for_th

  def lang_for_th
    { 'en_GB' => :en_uk,
      'en_US' => :en_us,
      ...
    }[lang]
  end
```

## Exceptions

Since the underlying [hyphenation algorithm](http://www.tug.org/docs/liang/) does not yield absolutely perfect results,
there is the possibility of defining **exceptions** - not yet implemented.

