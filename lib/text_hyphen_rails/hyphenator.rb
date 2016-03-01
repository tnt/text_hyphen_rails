module TextHyphenRails
  class Hyphenator

    def initialize
      raise 'don\'t use this class directly'
    end

    private

    def regex
      @rx ||= /[[:alpha:]]{#{@opts[:min_word_length]},}/m
    end

    def hyphenator
      @hyph ||= ::Text::Hyphen.new(language: @opts[:lang],
                                   left: @opts[:left],
                                   right: @opts[:right])
    end
  end
end
