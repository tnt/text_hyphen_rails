require 'text_hyphen_rails/engine'

module TextHyphenRails

  @settings = { hyphen: "\u00ad",
                lang: :en_uk,
                lang_att: nil,
                min_word_length: 4,
                left: 1,
                right: 1,
                prefix: nil,
                suffix: :hyph,
                replace_meth: false }


  @settings.each do |name, _|
    define_singleton_method(name) do |val|
      @settings[name] = val
    end
  end

  class << self
    attr_reader :settings
    def configure
      yield self
    end
  end
end
