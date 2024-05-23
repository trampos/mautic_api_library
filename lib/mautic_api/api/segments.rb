module MauticApi

  class Segments < Api
    
    ENDPOINT = "segments"
    LIST_NAME = "segments"
    ITEM_NAME = "segment"
    
    # Add a contact to the segment
    #
    # @param int $id      Segment ID
    # @param int $contactId Contact ID
    #
    # @return array|mixed
    
    def add_contact id, contact_id
      return make_request("#{self.endpoint}/#{id}/contact/#{contact_id}/add", {}, :post)
    end

    # Remove a contact from the segment
    #
    # @param int $id      Segment ID
    # @param int $contactId Contact ID
    #
    # @return array|mixed
    
    def remove_contact id, contact_id
      return make_request("#{self.endpoint}/#{id}/contact/#{contact_id}/remove", {}, :post)
    end

  end
  
end