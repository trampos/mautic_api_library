module MauticApi

  class Segments < Api
    
    ENDPOINT = 'segments'

    # Add a contact to the segment
    #
    # @param int $id      Segment ID
    # @param int $contactId Contact ID
    #
    # @return array|mixed
    
    def add_contact id, contact_id
      return make_request("#{self.endpoint}/#{id}/contact/add/#{contact_id}", {}, :post)
    end

    # Remove a contact from the segment
    #
    # @param int $id      Segment ID
    # @param int $contactId Contact ID
    #
    # @return array|mixed
    
    def remove_contact id, contact_id
      return make_request("#{self.endpoint}/#{id}/contact/remove/#{contact_id}", {}, :post)
    end

  end
  
end