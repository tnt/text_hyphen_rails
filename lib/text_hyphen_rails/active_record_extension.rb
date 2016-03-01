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
          g_opts = thr_g_opts att, opts
          self.send(:define_method, thr_meth_name(att, g_opts)) do
            str = read_attribute att
            opts = thr_opts g_opts
            h_class.new(str, opts).result
          end
        end

      end

      def thr_meth_name(att, opts)
        if opts[:replace_meth]
          att
        else
          [opts[:prefix], att, opts[:suffix]].reject(&:nil?).join('_')
        end
      end

      def thr_g_opts(meth, opts)
        raise UnknownOptionError if (opts.keys - TextHyphenRails.settings.keys).size > 0
        TextHyphenRails.settings.merge opts
      end
    end

    def thr_opts opts
      if opts[:lang_att]
        lang = self.send(opts[:lang_att])
        nopts = opts.dup
        nopts[:lang] = lang
        nopts
      else
        opts
      end
    end
  end
end

ActiveRecord::Base.send(:include, TextHyphenRails::ActiveRecordExtension)
