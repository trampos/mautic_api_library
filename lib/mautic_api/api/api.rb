module MauticApi
  
  class Api
    
    @@endpoint = ''
    @@base_api_endpoint = 'api'

    def initialize access_token
      @access_token = access_token
    end

    def action_not_supported action
      return {
        error: {
          code: 500,
          message: "#{action} is not supported at this time."
        }
      }
    end
    
    # Make the API request
    #
    # @param string $endpoint
    # @param array  $parameters
    # @param string $method
    #
    # @return array|mixed
    
    def make_request endpoint, parameters = {}, method = :get
    
      begin
        response = @access_token.request(method, "/#{@@base_api_endpoint}/#{endpoint}", parameters)
        json = JSON.parse(response.body)
        
        if response.code != 200
          
          if json['error'].present? && json['error_description'].present?
            message = "#{json['error']}: #{json['error_description']}"
            return {
              error: {
                code: 403,
                endpoint: "#{@@base_api_endpoint}/#{endpoint}",
                message: message
              }
            }
          end
          
          return {
            error: {
              code: response.code,
              endpoint: "#{@@base_api_endpoint}/#{endpoint}",
              message: response
            }
          }
        end
        
      rescue Exception => e
        
        return {
          error: {
            code: 500,
            endpoint: "#{@@base_api_endpoint}/#{endpoint}",
            message: e.message,
            backtrace: e.backtrace.join("\n")  
          }
        }
        
      end
      
      return json
    end
        
    # Get a single item
    #
    # @param int $id
    #
    # @returnarray|mixed
    
    def get id
      return access_token.get("{@@endpoint}/#{id}")
    end

    # Get a list of items
    #
    # @param string $search
    # @param int    $start
    # @param int    $limit
    # @param string $orderBy
    # @param string $orderByDir
    # @param bool   $publishedOnly
    #
    # @return array|mixed
    
    def get_list search = '', start = 0, limit = 0, order_by = '', order_by_dir = 'ASC', published_only = false
      
      parameters = {}
      
      args = ['search', 'start', 'limit', 'order_by', 'order_by_dir', 'published_only']

      args.each do |arg|
        parameters[arg.to_sym] = (eval arg) if (eval arg).present?
      end

      return make_request(@@endpoint, parameters)
    end

    
    # Proxy function to getList with $publishedOnly set to true
    #
    # @param string $search
    # @param int    $start
    # @param int    $limit
    # @param string $orderBy
    # @param string $orderByDir
    #
    # @return array|mixed
    
    def get_published_list search = '', start = 0, limit = 0, order_by = '', order_by_dir = 'ASC'
      return get_list(search, start, limit, order_by, order_by_dir, true)
    end

    
    # Create a new item (if supported)
    #
    # @param array $parameters
    #
    # @return array|mixed
    
    def create parameters
      return make_request("#{@@endpoint}/new", parameters, :post)
    end
    
    # Edit an item with option to create if it doesn't exist
    #
    # @param int   $id
    # @param array $parameters
    # @param bool  $createIfNotExists = false
    #
    # @return array|mixed
  
    def edit(id, parameters, create_if_not_exists = false)
      method = create_if_not_exists ? :put : :patch
      return make_request("#{@@endpoint}/#{id}/edit", parameters, method)
    end

    # Delete an item
    #
    # @param $id
    #
    # @return array|mixed
    
    def delete id
      return make_request("#{@@endpoint}/#{id}/delete", {}, :delete)
    end
  
  end
  
end