require "trailblazer/option"

module Declarative
  module Builder
    def self.included(base)
      base.extend DSL
      base.extend Build
    end

    class Builders < Array
      def call(context, *args, **options)
        each do |block|
          klass = block.(*args, exec_context: context, keyword_arguments: options) and return klass # Trailblazer::Option#call()
        end

        context
      end

      def <<(proc)
        super Trailblazer::Option( proc )
      end
    end

    module DSL
      def builders
        @builders ||= Builders.new
      end

      def builds(proc=nil, &block)
        builders << (proc || block)
      end
    end

    module Build
      # Call this from your class to compute the concrete target class.
      def build!(context, *args, **options)
        builders.(context, *args, **options)
      end
    end
  end
end


# Declarative::Builder(->(options) { options[:current_user] ? Bla : Blubb  })
