require 'net/http'
require 'uri'

module Missl
  class Middleware
    RESTRICTED_IPS = /^((10\.)|(127\.)|(169\.254)|(192\.168)|(172\.((1[6-9])|(2[0-9])|(3[0-1]))))/
    REDIRECT_LIMIT = 5

    def initialize(app, options = {})
      @app = app
      self
    end

    def call(env)
      if env["REQUEST_METHOD"] == "GET" && missl_path?(env["PATH_INFO"])
        proxy_image(env)
      else
        @app.call(env)
      end
    end

    protected
      def proxy_image(env, headers = {})
        request = Rack::Request.new(env)
        params = request.params

        # Make sure there is a URL.
        if params['url'].nil? || params['url'].empty?
          return [404, headers, []]
        end

        # Filter restricted IPs.
        if params['url'].match(RESTRICTED_IPS)
          return [403, headers, []]
        end

        # Make the request.
        resp = fetch(params['url'], REDIRECT_LIMIT)

        # Filter the content type.
        if resp['content-type'].slice(0, 5) != 'image'
          return [404, headers, []]
        end

        # Filter the content length.
        if resp['content-length'].to_i > 5242880
          return [404, headers, []]
        end

        # All done.
        headers['content-length'] = resp['content-length']
        headers['content-type'] = resp['content-type']
        [200, headers, [resp.body]]
      end

      def fetch(uri, redirect_limit)
        raise ArgumentError, "Too many redirects" unless redirect_limit > 0
        
        resp = Net::HTTP.get_response(URI.parse(uri))
        case resp
        when Net::HTTPSuccess then resp
        when Net::HTTPRedirection then fetch(resp['location'], redirect_limit - 1)
        else
          resp.error!
        end
      end

      def missl_path?(request_path)
        request_path.include?("/missl")
      end

  end
end