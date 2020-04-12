defmodule AzSaas.API do
  @moduledoc false

  use HTTPoison.Base

  @base_url "https://marketplaceapi.microsoft.com/api/saas"

  def process_request_url(url) do
    @base_url <> url
  end

  # try to decode JSON body
  def process_response_body(body) do
    case Jason.decode(body) do
      {:ok, term} -> term
      {:error, _} -> body
    end
  end

  # overwriteable request headers
  def process_request_headers(list) do
    request_id = :crypto.strong_rand_bytes(24) |> Base.encode64()

    list ++ [
      {"content-type", "application/json"},
      {"x-ms-requestid", request_id}
    ]
  end

  # overwriteable "?api-version" query param
  def process_request_options(options) do
    default_api_version = Application.get_env(:az_saas, :api_version, "2018-08-31")

    Keyword.update(
      options,
      :params,
      %{"api-version" => default_api_version},
      fn params -> Map.put_new(params, "api-version", default_api_version) end
    )
  end
end
