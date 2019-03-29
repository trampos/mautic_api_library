
# @copyright   2014 Mautic Contributors. All rights reserved
# @author      Mautic, Inc.
#
# @link        https://mautic.org
#
# @license     GNU/GPLv3 http://www.gnu.org/licenses/gpl-3.0.html
 
module MauticApi::Auth

    class OAuth2 < AuthInterface

        attr_accessor :access_token, :response_info

        def initialize access_token, parameters={}
            self.access_token = access_token
        end

        def is_authorized
            #Check for existing access token
            return self.access_token && !self.access_token.expired?
        end

        def get_response_info
            self.response_info
        end
        
        # Make a request to server using oauth2
        #
        # @param string $url
        # @param array  $parameters
        # @param string $method
        # @param array  $settings
        #
        # @return array

        def make_request url, parameters = {}, method = :get, settings = {}, &block
            
            case method
            when :get
                self.response_info = self.access_token.get(url, :params => parameters, &block)
            when :post
                self.response_info = self.access_token.post(url, :body => parameters, &block)
            when :put
                self.response_info = self.access_token.put(url, :body => parameters, &block)
            when :patch
                self.response_info = self.access_token.patch(url, :body => parameters, &block)
            when :delete
                self.response_info = self.access_token.delete(url, :body => parameters, &block)
            end

            return {
                url: url,
                method: method,
                parameters: parameters,
                settings: settings,
                code: self.response_info.status,
                body: self.response_info.parsed
            }
        end
    end
end