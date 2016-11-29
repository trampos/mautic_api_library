# @package     Mautic
# @copyright   2016 trampos.co. All rights reserved.
# @author      marcel@trampos.co
# @link        http://trampos.co
# @license     MIT http://opensource.org/licenses/MIT

require "mautic_api/engine"

module MauticApi
  
  autoload :Api,                            'mautic_api/api/api'
  autoload :Contacts,                       'mautic_api/api/contacts'
  autoload :Companies,                      'mautic_api/api/companies'
  autoload :Segments,                       'mautic_api/api/segments'
  autoload :ContextNotFoundException,       'mautic_api/exception/context_not_found_exception'

  class Context
    
    # Get an API context object
    #
    # @param string        $apiContext API context (leads, forms, etc)
    # @param AuthInterface $auth       API Auth object
    # @param string        $baseUrl    Base URL for API endpoints
    #
    # @return Api\Api
    # @throws ContextNotFoundException

    def new_api api_context
      api_context = api_context.camelize
      class_name = "MauticApi::#{api_context}"

      if Object.const_defined?(class_name)
        return class_name.constantize.new(access_token)
      else
        raise ContextNotFoundException "A context of 'api_context' was not found."
      end
    end

    private

    def redis
      @redis ||= Redis.new
    end

    def consumer
      return OAuth::Consumer.new(app_key, app_secret, { :site => base_url })
    end

    def access_token
      hash = {
        :oauth_token         => redis.get('mautic_api:access_token'),
        :oauth_token_secret  => redis.get('mautic_api:access_token_secret')
      }
      return OAuth::AccessToken.from_hash(consumer, hash)
    end

    def app_key
      redis.get('mautic_api:app_key')
    end

    def app_secret
      redis.get('mautic_api:app_secret')
    end

    def base_url
      redis.get('mautic_api:url')
    end
  
  end
  
end