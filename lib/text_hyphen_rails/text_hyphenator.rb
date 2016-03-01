module TextHyphenRails
  class TextHyphenator < Hyphenator

    def initialize text, options
      @text = text
      @opts = options
    end

    def result
      @text.gsub regex do |tok|
        hyphenator.visualize(tok, @opts[:hyphen])
      end
    end
  end
end
