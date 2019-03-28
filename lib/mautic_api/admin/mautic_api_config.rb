require "oauth"
require "redis"

if defined?(ActiveAdmin)
  ActiveAdmin.register_page "Mautic Api Config" do
    
    content do
      render partial: "mautic_api_form"
    end
    
    controller do
      
      def index
        @config = {
          url: redis.get('mautic_api:url'),
          key: redis.get('mautic_api:app_key'),
          secret: redis.get('mautic_api:app_secret'),
          token: redis.get('mautic_api:access_token')
        }
      end
      
      private
      
      def redis
        @redis ||= Redis.new
      end
      
      def client
        url     = redis.get('mautic_api:url')
        key     = redis.get('mautic_api:app_key')
        secret  = redis.get('mautic_api:app_secret')
        
        return OAuth2::Client.new(key, secret, {
          :site           => url,
          :token_url      => '/oauth/v2/token',
          :authorize_url  => '/oauth/v2/authorize'
        })
      end
      
      def callback_url
        public_send("#{ActiveAdmin.application.default_namespace}_mautic_api_config_oauth_callback_url", locale: nil)
      end
    end
    
    page_action :auth, method: :post do
      begin
        redis.set('mautic_api:url', params[:mautic_api][:url])
        redis.set('mautic_api:app_key', params[:mautic_api][:key])
        redis.set('mautic_api:app_secret', params[:mautic_api][:secret])
        redis.set('mautic_api:access_token', "") # Reset token
        redis.set('mautic_api:access_token_secret', "") # Reset token

        redirect_to public_send("#{ActiveAdmin.application.default_namespace}_mautic_api_config_path"), notice: "key was set"
      rescue OAuth::Unauthorized
        redirect_to public_send("#{ActiveAdmin.application.default_namespace}_mautic_api_config_path"), notice: "Não autorizado."
      end
    end
    
    page_action :oauth, method: :post do
      begin
        @request_token = client.get_request_token(:oauth_callback => callback_url)

        redis.set('mautic_api:oauth_token', @request_token.token)
        redis.set('mautic_api:oauth_token_secret', @request_token.secret)
      
        redirect_to @request_token.authorize_url(:oauth_callback => callback_url)
      rescue OAuth::Unauthorized
        redirect_to public_send("#{ActiveAdmin.application.default_namespace}_mautic_api_config_path"), notice: "Não autorizado."
      end
    end
    
    page_action :oauth_callback, method: :get do
      
      begin
        oauth_token = redis.get('mautic_api:oauth_token')
        oauth_token_secret = redis.get('mautic_api:oauth_token_secret')
      
        hash = { 
          oauth_token: oauth_token, 
          oauth_token_secret: oauth_token_secret
        }
      
        request_token  = OAuth::RequestToken.from_hash(client, hash)
        access_token = request_token.get_access_token({
          oauth_verifier: params[:oauth_verifier],
          oauth_callback: callback_url
        })
      
        redis.set('mautic_api:access_token', access_token.token)
        redis.set('mautic_api:access_token_secret', access_token.secret)
        
        redirect_to public_send("#{ActiveAdmin.application.default_namespace}_mautic_api_config_path"), notice: "token was set"
      rescue OAuth::Unauthorized
        redirect_to public_send("#{ActiveAdmin.application.default_namespace}_mautic_api_config_path"), notice: "Não autorizado."
      end
    end

  end
end