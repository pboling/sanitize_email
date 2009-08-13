#Copyright (c) 2008 Peter H. Boling of 9thBit LLC
#Released under the MIT license

module NinthBit
  module CustomEnvironments
    
    def self.included(base)
      base.extend(ClassMethods)
  
      base.cattr_accessor :local_environments
      base.local_environments = %w( development test )
      
      base.cattr_accessor :deployed_environments
      base.deployed_environments = %w( production staging )
    end

    module ClassMethods
      def consider_local?
        local_environments.include?(defined?(Rails) ? Rails.env : RAILS_ENV)
      end
      def consider_deployed?
        deployed_environments.include?(defined?(Rails) ? Rails.env : RAILS_ENV)
      end
    end
    
  end
end
