require 'text-hyphen'

module TextHyphenRails

  class UnknownOptionError < StandardError; end

  module ActiveRecordExtension

    extend ActiveSupport::Concern

    module ClassMethods

      def text_hyphen(*args, **opts)
        thr_create_methods(TextHyphenator, args, opts)
      end

      def html_hyphen(*args, **opts)
        thr_create_methods(HtmlHyphenator, args, opts)
      end

      private

      def thr_create_methods(h_class, args, opts)
        args.each do |att|
          m_opts = thr_m_opts att, opts
          self.send(:define_method, thr_meth_name(att, m_opts)) do
            str = read_attribute att
            lang = _thr_lang m_opts
            h_class.new(str, lang, m_opts).result
          end
          self.send(:define_method, "#{att}_orig") { read_attribute att } if opts[:replace_meth]
        end

      end

      def thr_meth_name(att, opts)
        if opts[:replace_meth]
          att
        else
          [opts[:prefix], att, opts[:suffix]].reject(&:nil?).join('_')
        end
      end

      def thr_m_opts(meth, opts)
        raise UnknownOptionError if (opts.keys - TextHyphenRails.settings.keys).size > 0
        TextHyphenRails.settings.merge opts
      end
    end

    private

    def _thr_lang(opts)
      if opts[:lang_att]
        self.send(opts[:lang_att])
      else
        opts[:lang]
      end
    end

  end
end

ActiveRecord::Base.send(:include, TextHyphenRails::ActiveRecordExtension)
