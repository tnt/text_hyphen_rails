module TextHyphenRails

  class HtmlHyphenator < Hyphenator

    def initialize(text, lang, options)
      super
      @doc = Nokogiri::HTML.fragment text
    end

    def result
      @doc.traverse do |n|
        if n.is_a? Nokogiri::XML::Text
          n.content = n.content.gsub regex do |tok|
            hyphenator.visualize(tok, @opts[:hyphen])
          end
        end
      end
      @doc.to_s
    end

  end
end
