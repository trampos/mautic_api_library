module MauticApi
  class Api
  
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
    
    # Get a single item
    #
    # @param int $id
    #
    # @returnarray|mixed
    
    def get id
      return access_token.get("{@endpoint}/#{id}")
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
      
      args = ['search', 'start', 'limit', 'orderBy', 'orderByDir', 'publishedOnly']

      args.each do |arg|
        parameters[arg.to_sym] = (eval arg) unless (eval arg).empty?
      end

      return make_request(@endpoint, parameters)
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
    
    def create attrs
      return make_request("#{@endpoint}/new", attrs, 'POST')
    end
    
    # Edit an item with option to create if it doesn't exist
    #
    # @param int   $id
    # @param array $parameters
    # @param bool  $createIfNotExists = false
    #
    # @return array|mixed
  
    def edit(id, attrs, create_if_not_exists = false)
      method = create_if_not_exists ? 'PUT' : 'PATCH'
      return make_request("#{@endpoint}/#{id}/edit", attrs, method)
    end

    # Delete an item
    #
    # @param $id
    #
    # @return array|mixed
    
    def delete id
      return make_request("#{@endpoint}/#{id}/delete", {}, 'DELETE')
    end
  }
end