# DynectEmail

A Ruby library for interacting with DynECT Email Delivery API.

[DynECT Email](http://dyn.com/enterprise-email/dynect-email)
[DynECT Email API](https://dynectemail.tenderapp.com/help/kb/api/introduction-to-dynect-email-deliverys-api)

## Installation

### From Git

You can check out the latest source from git:

    git clone git://github.com/Shopify/dynect_email.git

## Usage Example

```ruby
require 'rubygems'
require 'dynect_email'

# Set your API key
DynectEmail.api_key = "your-api-key"

# Add a sender to your account
DynectEmail.add_sender("myemail@example.com")

# Add a sub account with username, password, company, phone
response = DynectEmail.add_account("myemail@example.com", "secretpassword", "Shopify", "1231231231")

# response hash includes the api key for the account that was created
# Add a sender to the sub account
DynectEmail.add_sender("myemail@example.com", response['apikey'])

# Set headers
DynectEmail.set_headers({:xheader1 => "X-Sample1", :xheader2 => "X-Sample2"})

# Remove sender
DynectEmail.remove_sender("myemail@example.com")

# Remove account
DynectEmail.remove_account("myemail@example.com")
```

Check out the [API docs](https://dynectemail.tenderapp.com/help/kb/api/introduction-to-dynect-email-deliverys-api) for more information on what parameters are available.

## Contributing

1. Fork the [official repository](https://github.com/Shopify/dynect_email).
2. Make your changes in a topic branch.
3. Send a pull request.

Notes:

* Contributions without tests won't be accepted.
* Please don't update the Gem version.
