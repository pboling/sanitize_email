# Copyright (c) 2008-13 Peter H. Boling of RailsBling.com
# Released under the MIT license
# See http://www.seejohncode.com/2012/01/09/deprecating-methods-in-ruby/
#require 'facets/module/mattr' # gives cattr

module SanitizeEmail
  module Deprecation

    class << self
      attr_accessor :deprecate_in_silence
    end

    @deprecate_in_silence = false

    # Define a deprecated alias for a method
    # @param [Symbol] name - name of method to define
    # @param [Symbol] replacement - name of method to (alias)
    def deprecated_alias(name, replacement)
      # Create a wrapped version
      define_method(name) do |*args, &block|
        warn "SanitizeEmail: ##{name} deprecated (please use ##{replacement})" unless SanitizeEmail::Deprecation.deprecate_in_silence
        send replacement, *args, &block
      end
    end

    # Deprecate a defined method
    # @param [Symbol] name - name of deprecated method
    # @param [Symbol] replacement - name of the desired replacement
    def deprecated(name, replacement = nil)
      # Replace old method
      old_name = :"#{name}_without_deprecation"
      alias_method old_name, name
      # And replace it with a wrapped version
      define_method(name) do |*args, &block|
        self.deprecation(name, " (please use ##{replacement})")
        send old_name, *args, &block
      end
    end

    def deprecation(name, replacement = nil)
      unless SanitizeEmail::Deprecation.deprecate_in_silence
        if replacement
          warn "SanitizeEmail: ##{name} deprecated#{replacement}"
        else
          warn "SanitizeEmail: ##{name} deprecated"
        end
      end
    end

  end
end
