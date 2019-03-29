
# @copyright   2014 Mautic Contributors. All rights reserved
# @author      Mautic, Inc.
#
# @link        https://mautic.org
#
# @license     GNU/GPLv3 http://www.gnu.org/licenses/gpl-3.0.html
 
module MauticApi::Auth

    class OAuth2 < AuthInterface

        attr_accessor :access_token, :response_info

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

        def make_request url, parameters = {}, method = :get, &block
            case method
            when :get
                self.response_info = self.access_token.get(url, parameters, &block)
            when :post
                self.response_info = self.access_token.post(url, parameters, &block)
            when :put
                self.response_info = self.access_token.put(url, parameters, &block)
            when :patch
                self.response_info = self.access_token.patch(url, parameters, &block)
            when :delete
                self.response_info = self.access_token.delete(url, parameters, &block)
            end
        end

        def setup access_token
            self.access_token = access_token
        end
    end
end