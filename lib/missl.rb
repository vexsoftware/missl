require 'sinatra'
require 'net/http'
require 'uri'
require 'missi/version'

RESTRICTED_IPS = /^((10\.)|(127\.)|(169\.254)|(192\.168)|(172\.((1[6-9])|(2[0-9])|(3[0-1]))))/

get '/' do
  # Filter restricted IPs.
  if params[:uri].match(RESTRICTED_IPS)
    return 403
  end

  # Make the request.
  resp = Net::HTTP.get_response(URI.parse(params[:uri]))

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
