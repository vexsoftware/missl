module Missl
  module ViewHelper
    def missl_path(options = {})
      options = {
        :url => nil
      }.merge(options)

      "/missl" + ((options[:url].nil?) ? "" : "?url=#{CGI.escape(options[:url].to_str)}")
    end

    def missl_url(options = {})
      options = {
        :url => nil
      }.merge(options)

      "#{request.protocol}#{request.host_with_port}#{missl_path(options)}"
    end
  end
end