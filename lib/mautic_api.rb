# @package     Mautic
# @copyright   2016 trampos.co. All rights reserved.
# @author      marcel@trampos.co
# @link        http://trampos.co
# @license     MIT http://opensource.org/licenses/MIT

require "mautic_api/engine"

module MauticApi
    
    autoload :Auth,                           'mautic_api/auth/auth'
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

        def new_api api_context, auth, base_url=""
            
            class_name = "MauticApi::#{api_context.camelize}"

            if Object.const_defined?(class_name)
                return class_name.constantize.new(auth, base_url)
            else
                raise ContextNotFoundException "A context of 'api_context' was not found."
            end
        end
    end
end