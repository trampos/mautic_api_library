module MauticApi

  class Contacts < Api

    @endpoint = 'contacts'
    
    def get_owners
      return get("#{@endpoint}/list/owners");
    end
    
    /**
     * Get a list of custom fields
     *
     * @return array|mixed
     */
    public function getFieldList()
    {
        return $this->makeRequest($this->endpoint.'/list/fields');
    }
    /**
     * Get a list of contact segments
     *
     * @return array|mixed
     */
    public function getSegments()
    {
        return $this->makeRequest($this->endpoint.'/list/segments');
    }
    /**
     * Get a list of a contact's notes
     *
     * @param int    $id Contact ID
     * @param string $search
     * @param int    $start
     * @param int    $limit
     * @param string $orderBy
     * @param string $orderByDir
     *
     * @return array|mixed
     */
    public function getContactNotes($id, $search = '', $start = 0, $limit = 0, $orderBy = '', $orderByDir = 'ASC')
    {
        $parameters = array();
        $args = array('search', 'start', 'limit', 'orderBy', 'orderByDir');
        foreach ($args as $arg) {
            if (!empty($$arg)) {
                $parameters[$arg] = $$arg;
            }
        }
        return $this->makeRequest($this->endpoint.'/'.$id.'/notes', $parameters);
    }
    /**
     * Get a segment of smart segments the lead is in
     *
     * @param $id
     * @return array|mixed
     */
    public function getContactSegments($id)
    {
        return $this->makeRequest($this->endpoint.'/'.$id.'/segments');
    }
    /**
     * Get a segment of campaigns the lead is in
     *
     * @param $id
     * @return array|mixed
     */
    public function getContactCampaigns($id)
    {
        return $this->makeRequest($this->endpoint.'/'.$id.'/campaigns');
    }
}