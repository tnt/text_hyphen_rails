require 'text-hyphen'

module TextHyphenRails

  class UnknownOptionError < StandardError; end

  module ActiveRecordExtension

    extend ActiveSupport::Concern

    module ClassMethods
      def text_hyphen(*args, **opts)
        args.each do |att|
          opts = thr_opts att, opts
          self.send(:define_method, thr_meth_name(att, opts)) do
            str = read_attribute att

            str.gsub opts[:word_regex] do |tok|
              thr_hyphenator(opts).visualize tok, opts[:hyphen]
            end
          end
        end
      end

      private

      def thr_meth_name(att, opts)
        if opts[:replace_meth]
          att
        else
          [opts[:prefix], att, opts[:suffix]].reject(&:nil?).join('_')
        end
      end

      def thr_opts(meth, opts)
        raise UnknownOptionError if (opts.keys - TextHyphenRails.settings.keys).size > 0
        TextHyphenRails.settings.merge opts
      end
    end

    private

    def thr_hyphenator opts
      lang = if opts[:lang_att]
               self.send(opts[:lang_att])
             else
               opts[:lang]
             end
      ::Text::Hyphen.new(language: lang,
                         left: opts[:left],
                         right: opts[:right])
    end
  end
end

ActiveRecord::Base.send(:include, TextHyphenRails::ActiveRecordExtension)
