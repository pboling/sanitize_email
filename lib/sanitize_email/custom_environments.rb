#Copyright (c) 2008-9 Peter H. Boling of 9thBit LLC
#Released under the MIT license

module NinthBit
  module CustomEnvironments
    
    def self.included(base)
      base.extend(ClassMethods)
  
      base.cattr_accessor :local_environments
      base.local_environments = %w( development test )
    end

    module ClassMethods
      def consider_local?
        local_environments.include?(defined?(Rails) ? Rails.env : RAILS_ENV)
      end
    end
    
  end
end
