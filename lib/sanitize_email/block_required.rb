module SanitizeEmail

  class MissingBlockParameter < StandardError; end

  module BlockRequired

    def block_required_check(method_name)
      raise MissingBlockParameter, "SanitizeEmail.#{method_name} must be called with a block" unless block_given?
    end

    def self.sanitary(*_)
      block_required_check("sanitary")
    end

    def self.unsanitary(*_)
      block_required_check("unsanitary")
    end

    def self.janitor(*_)
      block_required_check("janitor")
    end

  end

end
