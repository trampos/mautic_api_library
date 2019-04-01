
# Autorizando

```ruby

    require 'oauth2'

    client_id = ''
    client_secret = ''

    client = OAuth2::Client.new(client_id, client_secret, { 
        :site             => mautic_url,
        :authorize_url    => '/oauth/v2/authorize',
        :token_url        => '/oauth/v2/token' })

    client.auth_code.authorize_url(:redirect_uri => mautic_oauth_callback)

```

# Callback, pegando a token

```ruby

    code = params[:code]
    token = client.auth_code.get_token code, :redirect_uri => mautic_oauth_callback

    auth = MauticApi::Auth::OAuth2.new token

```

# Usando a token

```ruby


    context = MauticApi::Context.new
    api = context.new_api "contacts", auth, mautic_api_base_url

    # PATCH contato
    api.edit 1707484, { lastname: "Ueno" }

    # GET contato
    api.get 1707484

```
