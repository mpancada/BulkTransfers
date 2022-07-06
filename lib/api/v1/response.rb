class Api::V1::Response

    attr_reader :data, :message

    def initialize data, message=""
        @data       = data
        @message    = message
    end
end
