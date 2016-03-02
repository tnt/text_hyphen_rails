# text_hyphen_rails
[![Build Status](https://travis-ci.org/tnt/text_hyphen_rails.svg)](https://travis-ci.org/tnt/text_hyphen_rails)

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

There is also an `html_hyphen`-method which does the same but doesn't hyphenate HTML tags.

## Settings

You can specify a number of settings globally or per method(s).

```ruby
  # in an initializer
  TextHyphenRails.configure do |cnf|
    cnf.lang :de1
  end

  # per method
  text_hyphen :content, lang: :en_uk, hyphen: '&shy;'
  html_hyphen :another_att, lang: :de1
```
The follwing options are available:

| name            |    default                | description                                                                     |
|-----------------|:-------------------------:|---------------------------------------------------------------------------------|
| hyphen          | "\u00ad"                  | the hyphen                                                                      |
| lang            | :en_uk                    | the identifier of the language, one of: `:ca :cs :da :de1 :de2 :en_uk :en_us :es :et :eu :fi :fr :ga :hr :hsb :hu1 :hu2 :ia :id :is :it :la :mn :nl :no1 :no2 :pl :pt :ru :sv` |
| lang_att        | nil                       | name of an attribute (method or column) that returns a language-identifier      |
| min_word_length | 4                         | minimal length of word to by hyphenated   |
| left / right    | 1 / 1                     | I'm not sure     |
| prefix / suffix | nil / :hyph               | prefix / suffix for the created methods (have no effect when `replace_meth` is `true`)    |
| replace_meth    | false                     | replace the original method (or attribute-getter?) with the hyphenating one and create an additional one with `_orig` suffix  |


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

### `replace_meth`

```ruby
  html_hyphen :text, replace_meth: true
```

Creates a hyphenating `text`-method and a `text_orig`-method to access the unmodified value.
You should use the `_orig`-variant in forms because otherwise the hyphenated text would be saved in the db after editing.


## Exceptions

Since the underlying [hyphenation algorithm](http://www.tug.org/docs/liang/) does not yield absolutely perfect results,
there is the possibility of defining **exceptions** - not yet implemented.

