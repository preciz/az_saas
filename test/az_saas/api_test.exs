defmodule AzSaas.ApiTest do
  use ExUnit.Case

  test "api-version defaults to 2018-08-31" do
    params =
      []
      |> AzSaas.API.process_request_options()
      |> Keyword.get(:params)

    assert %{"api-version" => "2018-08-31"} = params
  end

  test "api-version query param is overwriteable" do
    params =
      [params: %{"api-version" => "anything"}]
      |> AzSaas.API.process_request_options()
      |> Keyword.get(:params)

    assert %{"api-version" => "anything"} = params
  end
end
