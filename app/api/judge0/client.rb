# frozen_string_literal: true

module Judge0
  class Client
    def self.statuses
      Request.call(http_method: :get, endpoint: '/statuses')
    end

    def self.languages
      Request.call(http_method: :get, endpoint: '/languages')
    end

    def self.all_languages
      Request.call(http_method: :get, endpoint: '/languages/all')
    end

    def self.language(language_id:)
      raise ArgumentError, 'Invalid language ID' unless language_id.is_a?(Integer)

      Request.call(http_method: :get, endpoint: "/languages/#{language_id}")
    end

    def self.evaluate_source_code(source_code:, language_id:)
      raise ArgumentError, 'Missing required source code' if source_code.blank?
      raise ArgumentError, 'Invalid language ID' unless language_id.is_a?(Integer)

      Request.call(
        http_method: :post,
        endpoint: '/submissions/?base64_encoded=false&wait=true',
        body: { 'source_code': source_code, 'language_id': language_id }.to_json
      )
    end

    # NOTE: Deprecated as .evaluate_source_code provides both write and read functionalities for source code
    # def self.read_submission(token:, fields: %w[source_code stdout stderr status_id language_id token])
    #   raise ArgumentError, 'Missing required submission token' if token.nil?
    #
    #   Request.call(http_method: :get,
    #                endpoint: "/submissions/#{token}?base64_encoded=false&fields=#{fields.join(',')}")
    # end
  end
end
