require 'sinatra/base'
require 'net/http'
require 'uri'
require 'missl/version'

RESTRICTED_IPS = /^((10\.)|(127\.)|(169\.254)|(192\.168)|(172\.((1[6-9])|(2[0-9])|(3[0-1]))))/
REDIRECT_LIMIT = 5

module Missl
  class Base < Sinatra::Base
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

    get '/' do
      ::NewRelic::Agent.abort_transaction! if defined?(NewRelic)

      # Make sure there is a URL.
      if params[:url].nil? || params[:url].empty?
        return 404
      end

      # Filter restricted IPs.
      if params[:url].match(RESTRICTED_IPS)
        return 403
      end

      # Make the request.
      resp = fetch(params[:url], REDIRECT_LIMIT)

      # Filter the content type.
      if resp['content-type'].slice(0, 5) != 'image'
        return 404
      end

      # Filter the content length.
      if resp['content-length'].to_i > 5242880
        return 404
      end

      # All done.
      response.headers['content-length'] = resp['content-length']
      response.headers['content-type'] = resp['content-type']
      return resp.body
    end
  end
end