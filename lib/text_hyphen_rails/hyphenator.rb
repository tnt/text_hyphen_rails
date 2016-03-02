module TextHyphenRails

  class Hyphenator

    def initialize(text, lang, options)
      @opts = options
      @lang = lang
    end

    private

    def regex
      n = @opts[:min_word_length]
      @rx ||= Regexp.new("[[:alpha:]]{#{n},}")
    end

    def hyphenator
      @hyph ||= ::Text::Hyphen.new(language: @lang,
                                   left: @opts[:left],
                                   right: @opts[:right])
    end

  end
end
