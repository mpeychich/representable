module Representable::XML
  module Collection
    include Representable::XML

    def self.included(base)
      base.class_eval do
        include Representable
        extend ClassMethods
      end
    end


    module ClassMethods
      def items(options)
        collection :_self, options
      end
    end


    def create_representation_with(doc, options, format)
      bin   = representable_bindings_for(format, options).first
      bin.write(doc, represented)
    end

    def update_properties_from(doc, options, format)
      bin   = representable_bindings_for(format, options).first
      value = bin.deserialize_from(doc.search("./*")) # FIXME: use Binding#read.
      represented.replace(value)
    end

    # FIXME: refactor Definition so we can simply add options in #items to existing definition.
    def representable_attrs
      attrs = super
      attrs << Definition.new(:_self, :collection => true) if attrs.size == 0
      attrs
    end
  end
end
