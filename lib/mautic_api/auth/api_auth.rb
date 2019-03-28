

 # @copyright   2014 Mautic Contributors. All rights reserved
 # @author      Mautic, Inc.
 #
 # @link        https://mautic.org
 #
 # @license     GNU/GPLv3 http://www.gnu.org/licenses/gpl-3.0.html

module MauticApi::Auth
  
#         # OAuth Client modified from https://code.google.com/p/simple-php-oauth/

    class ApiAuth
        
#             # Get an API Auth object
#             #
#             # @param array  $parameters
#             # @param string auth_method
#             #
#             # @return AuthInterface
#             #
#             # @deprecated
        
#             def self.initialize parameters = [], auth_method = :o_auth
#                 object = self.new
#                 return object.new_auth parameters, auth_method
#             end
  
#             # Get an API Auth object
#             #
#             # @param array  $parameters
#             # @param string auth_method
#             #
#             # @return AuthInterface

#             def new_auth parameters = {}, auth_method = :o_auth
  
#                 klass       = "MauticApi::Auth::#{auth_method.camelize}".constantize
#                 auth_object = klass.new
#                 auth_setup  = auth_object.method(:setup)
#                 pass        = []

#                 auth_setup.parameters.each do |method, param|
#                     if parameters[param.to_sym]
#                         pass << parameters[param.to_sym]
#                     else
#                         pass << nil
#                     end
#                 end

#                 auth_setup.call(*pass)

#                 return auth_object
#             end
    end
end