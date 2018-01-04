module MauticApi

  class Contacts < Api

    ENDPOINT = 'contacts'

    # Get a list of users available as contact owners
    #
    # @return array|mixed

    def get_owners
      return make_request("#{self.endpoint}/list/owners")
    end

    # Get a list of custom fields
    #
    # @return array|mixed

    def get_field_list
      return make_request("#{self.endpoint}/list/fields")
    end

    # Get a list of contact segments
    #
    # @return array|mixed

    def get_segments
      return make_request("#{self.endpoint}/list/segments")
    end

    # Get a list of a contact's notes
    #
    # @param int    $id Contact ID
    # @param string $search
    # @param int    $start
    # @param int    $limit
    # @param string $orderBy
    # @param string $orderByDir
    #
    # @return array|mixed

    def get_contact_notes id, search = '', start = 0, limit = 0, orderBy = '', order_by_dir = 'ASC'

      parameters = {}

      args = ['search', 'start', 'limit', 'orderBy', 'order_by_dir']

      args.each do |arg|
        parameters[arg.to_sym] = (eval arg) if (eval arg).present?
      end

      return make_request("#{self.endpoint}/#{id}/notes", parameters)
    end

    # Get a segment of smart segments the lead is in
    #
    # @param $id
    # @return array|mixed

    def get_contact_segments(id)
      return make_request("#{self.endpoint}/#{id}/segments")
    end

    # Add do not contact to lead
    #
    # @param int    $id Contact ID
    # @param string $comments
    #
    # @return array|mixed

    def add_do_not_contact id, reason = 1, comments = ''
      parameters = {}

      args = ['reason', 'comments']

      args.each do |arg|
        parameters[arg.to_sym] = (eval arg) if (eval arg).present?
      end

      return make_request("#{self.endpoint}/#{id}/dnc/add/email", parameters, :post)
    end

    # Get a segment of campaigns the lead is in
    #
    # @param $id
    # @return array|mixed

    def get_contact_campaigns(id)
      return make_request("#{self.endpoint}/#{id}/campaigns")
    end

  end

end
