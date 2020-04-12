# AzSaas
Elixir wrapper for Azure Marketplace SaaS fulfillment APIs version 2.

Documentation can be found at [https://hexdocs.pm/az_saas](https://hexdocs.pm/az_saas).

## Installation

Add `az_saas` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:az_saas, "~> 0.1.0"}
  ]
end
```

## Usage

For the production API you need an access-token.
See: [Register a SaaS application](https://docs.microsoft.com/en-us/azure/marketplace/partner-center-portal/pc-saas-registration)

```elixir
  iex> AzSaas.list_subscriptions("myRealTokenHere")
  {:ok, %HTTPoison.Response{...}}
```

## API versions
production API version (default): `"2018-08-31"`

mock API version: `"2018-08-31"`

To set the `api-version` query param:

## Using mock API example 1
```elixir
iex> AzSaas.list_subscriptions("noRealTokenForMockAPIRequired", [], [params: %{"api-version" => "2018-09-15"})
```

## Using mock API example 2
```elixir
iex> Application.put_env(:az_saas, :api_version, "2018-09-15")
iex> AzSaas.list_subscriptions("noRealTokenForMockAPIRequired")
```

## License

AzSaas is [MIT licensed](LICENSE).
