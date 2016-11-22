module MauticApi
  class ContextNotFoundException < StandardError
    
    attr_reader :code
    
    def initialize data = 'Context not found.', code = 500
      @data = data
      @code = code
    end
  end
end