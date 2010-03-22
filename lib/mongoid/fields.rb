# encoding: utf-8
module Mongoid #:nodoc
  module Fields #:nodoc
    def self.included(base)
      base.class_eval do
        extend ClassMethods
        # Set up the class attributes that must be available to all subclasses.
        # These include defaults, fields
        class_inheritable_accessor :fields

        self.fields = {}

        delegate :defaults, :fields, :to => "self.class"
      end
    end

    module ClassMethods #:nodoc
      # Defines all the fields that are accessable on the Document
      # For each field that is defined, a getter and setter will be
      # added as an instance method to the Document.
      #
      # Options:
      #
      # name: The name of the field, as a +Symbol+.
      # options: A +Hash+ of options to supply to the +Field+.
      #
      # Example:
      #
      # <tt>field :score, :default => 0</tt>
      def field(name, options = {})
        access = name.to_s
        set_field(access, options)
      end

      # Returns the default values for the fields on the document
      def defaults
        fields.inject({}) do |defs,(field_name,field)|
          next(defs) if field.default.nil?
          defs[field_name.to_s] = field.default
          defs
        end
      end

      protected
      # Define a field attribute for the +Document+.
      def set_field(name, options = {})
        meth = options.delete(:as) || name
        fields[name] = Field.new(name, options)
        create_accessors(name, meth, options)
      end

      # Create the field accessors.
      def create_accessors(name, meth, options = {})
        define_method(meth) { read_attribute(name) } unless method_defined?(meth)
        define_method("#{meth}=") do |value|
          write_attribute(name, value)
        end unless method_defined?("#{meth}=")
        define_method("#{meth}?") do
          attr = read_attribute(name)
          (options[:type] == Boolean) ? attr == true : attr.present?
        end unless method_defined?("#{meth}?")
      end
    end
  end
end
