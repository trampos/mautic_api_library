module MauticApi
  class Engine < ::Rails::Engine
    isolate_namespace MauticApi

    initializer :mautic_api do
      # GG, Tirei do activeadmin
      # ActiveAdmin.application.load_paths.unshift Dir[File.dirname(__FILE__) + '/admin']
    end
  end
end