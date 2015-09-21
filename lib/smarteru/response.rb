module Smarteru
  class Response
    attr_reader :data, :hash, :opts

    # Initializes an API response
    #
    # ==== Attributes
    # * +resp+ - RestClient response from the API
    def initialize(res, opts = {})
      @data = res
      @parser = opts[:parser] || default_parser
      @opts = opts
    end

    # Hash representation of response data
    def hash
      @hash ||= @parser.parse(data.to_s)
    end

    # Return true/false based on the API response status
    def success?
      hash[:smarter_u][:result] == 'Success'
    rescue
      false
    end

    def result
      hash[:smarter_u][:info]
    end

    def error
      errors = hash[:smarter_u][:errors]
      errors.is_a?(Hash) ? errors : nil
    end

    private

    def default_parser
      Nori.new(
        advanced_typecasting: false,
        convert_tags_to: lambda { |tag| tag.snakecase.to_sym }
      )
    end
  end
end
