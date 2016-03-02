module TextHyphenRails

  class TextHyphenator < Hyphenator

    def initialize(text, lang, options)
      super
      @text = text
    end

    def result
      @text.gsub regex do |tok|
        hyphenator.visualize(tok, @opts[:hyphen])
      end
    end

  end
end
