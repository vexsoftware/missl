require 'missl/view_helper'

module Missl
  class Engine < ::Rails::Engine
    config.after_initialize do
      ActionView::Base.send(:include, Missl::ViewHelper)
    end

    config.app_middleware.use Missl::Middleware
  end
end