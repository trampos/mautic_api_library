require "active_admin"

module MauticApi
  class Engine < ::Rails::Engine
    isolate_namespace MauticApi

    initializer :mautic_api do
      Rails.logger.info File.dirname(__FILE__) + '/mautic_api/admin'
      ActiveAdmin.application.load_paths.unshift Dir[File.dirname(__FILE__) + '/mautic_api/admin']
    end
  end
end