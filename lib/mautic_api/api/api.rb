module MauticApi

    class Api

        attr_accessor :base_url, :auth

        ENDPOINT = ""
        LIST_NAME = ""
        ITEM_NAME = ""
        
        BASE_API_ENDPOINT = 'api'
    
        def endpoint
          self.class::ENDPOINT
        end
        
        def list_name 
            self.class::LIST_NAME
        end

        def item_name 
            self.class::ITEM_NAME
        end
        
        def base_api_endpoint
          self.class::BASE_API_ENDPOINT
        end
        
        def initialize auth, base_url
            @auth = auth
            set_base_url(base_url)
        end

        def set_base_url url
            url += "/" if url[-1] != "/"
            url += "api/" if url[-4,4] != "api/"
            @base_url = url
            return self 
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
        # @param        $endpoint
        # @param array  parameters
        # @param string method
        #
        # @return array
        # @throws \Exception

        def make_request endpoint, parameters = {}, method = :get, settings = {}
            
            response = {}

            # Validate if this endpoint has a BC url
            bc_endpoint = nil

            if @bc_attempt
                if @bc_regex_endpoints.present?
                    @bc_regex_endpoints.each do |regex, bc|

                        if endpoint.scan(/@#{regex}@/)
                            @bc_attempt = true
                            bcEndpoint = endpoint.gsub(/@#{regex}@/, bc)
                            break
                        end
                    end
                end
            end

            url = "#{@base_url}#{endpoint}"
            # Don't make the call if we're unit testing a BC endpoint

            if !bc_endpoint || !@bc_testing || (bc_endpoint && @bc_testing && @bc_attempt)

                # Hack for unit testing to ensure this isn't being called due to a bad regex
                # if @bc_testing && !@bc_attempt

                    # bt = debug_backtrace(DEBUG_BACKTRACE_IGNORE_ARGS, 2)
                    # if !@bc_testing.kind_of?(Array)
                    #     @bc_testing = [@bc_testing]
                    # end

                    # The method is not catching the BC endpoint so fail the test
                    # if @bc_testing.include?($bt[1]['function'])
                    #     throw new \Exception($endpoint.' not matched in '.var_export(@bc_regex_endpoints, true))
                    # }
                # end

                @bc_attempt = false

                if url.index('http').nil?
                    error = {
                        code: 500,
                        message: "URL is incomplete.  Please use #{}, set the base URL as the third argument to MauticApi.newApi, or make endpoint a complete URL."
                    }
                else

                    begin
                        settings = {}

                        if self.respond_to?(:get_temporary_file_path)
                            settings[:temporary_file_path] = self.get_temporary_file_path
                        end

                        response = @auth.make_request(url, parameters, method, settings)
                        
                        # TODO: $this->getLogger()->debug('API Response', array('response' => $response))
                        
                        if response[:code] >= 300
                            
                            # TODO: $this->getLogger()->warning($response)
                            # assume an error
                            
                            error = {
                                code: 500,
                                message: response[:body]
                            }
                        end

                    rescue Exception => e
                        # TODO: $this->getLogger()->error('Failed connecting to Mautic API: '.$e->getMessage(), array('trace' => $e->getTraceAsString()))

                        error = {
                            code: 500,
                            message: e
                        }
                    end
                end

                if error.present?
                    return { errors: [error] }
                end
                
                # Ensure a code is present in the error array
                # if response[:errors].present?
                #     info = @auth.get_response_info
                #     response[:errors].each do |key, error|
                #         if response[:errors][key]['code']
                #             response[:errors][key]['code'] = info['http_code']
                #         end
                #     end
                # end
            end

            # Check for a 404 code and a BC URL then try again if applicable
            # if bc_endpoint && (@bc_testing || (response['errors'][0]['code'].to_i === 404))
            #     @bc_attempt = true
            #     return self.make_request(bc_endpoint, parameters, method)
            # end

            return response
        end

        # Get a single item
        #
        # @param int $id
        #
        # @returnarray|mixed
        
        def get id
            return make_request("#{self.endpoint}/#{id}")
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

            return make_request(self.endpoint, parameters)
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
        # @param array parameters
        #
        # @return array|mixed
        
        def create parameters
            return make_request("#{self.endpoint}/new", parameters, :post)
        end
        
        # Edit an item with option to create if it doesn't exist
        #
        # @param int   $id
        # @param array parameters
        # @param bool  $createIfNotExists = false
        #
        # @return array|mixed
    
        def edit(id, parameters, create_if_not_exists = false)
            method = create_if_not_exists ? :put : :patch
            return make_request("#{self.endpoint}/#{id}/edit", parameters, method)
        end

        # Delete an item
        #
        # @param $id
        #
        # @return array|mixed
        
        def delete id
            return make_request("#{self.endpoint}/#{id}/delete", {}, :delete)
        end
        
    end
end