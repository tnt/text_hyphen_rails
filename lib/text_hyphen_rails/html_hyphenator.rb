module TextHyphenRails
  class HtmlHyphenator < Hyphenator
    def initialize text, options
      @doc = Nokogiri::HTML.fragment text
      @opts = options
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

    private

    def text_nodes
      # broken
      @doc.xpath('//text()')
    end
  end
end
