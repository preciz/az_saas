defmodule AzSaas do
  @moduledoc """
  Elixir wrapper for Azure Marketplace SaaS fulfillment APIs version 2.

  ## Usage

  For the production API you need an access-token.
  See: [Register a SaaS application](https://docs.microsoft.com/en-us/azure/marketplace/partner-center-portal/pc-saas-registration)

      iex> AzSaas.list_subscriptions("myRealTokenHere")
      {:ok, %HTTPoison.Response{...}}

  ## API versions
  production API version (default): `"2018-08-31"`

  mock API version: `"2018-08-31"`

  To set the `api-version` query param:

  ## Using mock API example 1
      iex> AzSaas.list_subscriptions("noRealTokenForMockAPIRequired", [], [params: %{"api-version" => "2018-09-15"})

  ## Using mock API example 2
      iex> Application.put_env(:az_saas, :api_version, "2018-09-15")
      iex> AzSaas.list_subscriptions("noRealTokenForMockAPIRequired")
  """

  alias AzSaas.API

  @doc """
  Lists all the SaaS subscriptions for a publisher.

  See: [Azure Marketplace docs](https://docs.microsoft.com/en-us/azure/marketplace/partner-center-portal/pc-saas-fulfillment-api-v2#list-subscriptions)
  """
  def list_subscriptions(access_token, headers \\ [], options \\ [])
      when is_binary(access_token) do
    headers = [authorization_header(access_token) | headers]

    API.get("/subscriptions", headers, options)
  end

  @doc """
  The resolve endpoint enables the `publisher to resolve a marketplace token to a persistent resource ID.

  See: [Azure Marketplace docs](https://docs.microsoft.com/en-us/azure/marketplace/partner-center-portal/pc-saas-fulfillment-api-v2#resolve-a-subscription)
  """
  def resolve_subscription(access_token, token, headers \\ [], options \\ [])
      when is_binary(access_token) and is_binary(token) do
    headers = [authorization_header(access_token), {"x-ms-marketplace-token", token} | headers]

    API.post("/subscriptions/resolve", "", headers, options)
  end

  @doc """
  Gets the specified SaaS subscription. Use this call to get license information and plan information.

  See: [Azure Marketplace docs](https://docs.microsoft.com/en-us/azure/marketplace/partner-center-portal/pc-saas-fulfillment-api-v2#get-subscription)
  """
  def get_subscription(access_token, subscription_id, headers \\ [], options \\ [])
      when is_binary(access_token) and is_binary(subscription_id) do
    headers = [authorization_header(access_token) | headers]

    API.get("/subscriptions/#{subscription_id}", headers, options)
  end

  @doc """
  Use this call to find out if there are any private or public offers for the current publisher.

  See: [Azure Marketplace docs](https://docs.microsoft.com/en-us/azure/marketplace/partner-center-portal/pc-saas-fulfillment-api-v2#list-available-plans)
  """
  def list_available_plans(access_token, subscription_id, headers \\ [], options \\ [])
      when is_binary(access_token) and is_binary(subscription_id) do
    headers = [authorization_header(access_token) | headers]

    API.get("/subscriptions/#{subscription_id}/listAvailablePlans", headers, options)
  end

  @doc """
  Update the plan on the subscription.

  See: [Azure Marketplace docs](https://docs.microsoft.com/en-us/azure/marketplace/partner-center-portal/pc-saas-fulfillment-api-v2#change-the-plan-on-the-subscription)
  """
  def change_plan(access_token, subscription_id, plan_id, headers \\ [], options \\ [])
      when is_binary(access_token) and is_binary(subscription_id) and is_binary(plan_id) do
    headers = [authorization_header(access_token) | headers]

    body = Jason.encode!(%{"planId" => plan_id})

    API.patch("/subscriptions/#{subscription_id}", body, headers, options)
  end

  @doc """
  Update the quantity on the subscription.

  See: [Azure Marketplace docs](https://docs.microsoft.com/en-us/azure/marketplace/partner-center-portal/pc-saas-fulfillment-api-v2#change-the-quantity-on-the-subscription)
  """
  def change_quantity(access_token, subscription_id, quantity, headers \\ [], options \\ [])
      when is_binary(access_token) and is_binary(subscription_id) and is_integer(quantity) do
    headers = [authorization_header(access_token) | headers]

    body = Jason.encode!(%{"quantity" => quantity})

    API.patch("/subscriptions/#{subscription_id}", body, headers, options)
  end

  @doc """
  Activate a subscription

  See: [Azure Marketplace docs](https://docs.microsoft.com/en-us/azure/marketplace/partner-center-portal/pc-saas-fulfillment-api-v2#activate-a-subscription)
  """
  def activate_subscription(
        access_token,
        subscription_id,
        plan_id,
        quantity,
        headers \\ [],
        options \\ []
      )
      when is_binary(access_token) and is_binary(subscription_id) and is_binary(plan_id) and
             is_integer(quantity) do
    headers = [authorization_header(access_token) | headers]

    body = Jason.encode!(%{"planId" => plan_id, "quantity" => quantity})

    API.post("/subscriptions/#{subscription_id}/activate", body, headers, options)
  end

  @doc """
  Unsubscribe and delete the specified subscription.

  See: [Azure Marketplace docs](https://docs.microsoft.com/en-us/azure/marketplace/partner-center-portal/pc-saas-fulfillment-api-v2#delete-a-subscription)
  """
  def delete_subscription(access_token, subscription_id, headers \\ [], options \\ [])
      when is_binary(access_token) and is_binary(subscription_id) do
    headers = [authorization_header(access_token) | headers]

    API.delete("/subscriptions/#{subscription_id}", headers, options)
  end

  @doc """
  Lists the outstanding operations for the current publisher.

  See: [Azure Marketplace docs](https://docs.microsoft.com/en-us/azure/marketplace/partner-center-portal/pc-saas-fulfillment-api-v2#list-outstanding-operations)
  """
  def list_outstanding_operations(access_token, subscription_id, headers \\ [], options \\ [])
      when is_binary(access_token) and is_binary(subscription_id) do
    headers = [authorization_header(access_token) | headers]

    API.get("/subscriptions/#{subscription_id}/operations", headers, options)
  end

  @doc """
  Enables the publisher to track the status of the specified triggered
  async operation (such as Subscribe, Unsubscribe, ChangePlan, or ChangeQuantity).

  See: [Azure Marketplace docs](https://docs.microsoft.com/en-us/azure/marketplace/partner-center-portal/pc-saas-fulfillment-api-v2#get-operation-status)
  """
  def get_operation_status(
        access_token,
        subscription_id,
        operation_id,
        headers \\ [],
        options \\ []
      )
      when is_binary(access_token) and is_binary(subscription_id) and is_binary(operation_id) do
    headers = [authorization_header(access_token) | headers]

    API.get("/subscriptions/#{subscription_id}/operations/#{operation_id}", headers, options)
  end

  @doc """
  Update the status of an operation to indicate success or failure with the provided values.

  See: [Azure Marketplace docs]
  """
  def update_operation_status(
        access_token,
        subscription_id,
        operation_id,
        plan_id,
        quantity,
        status,
        headers \\ [],
        options \\ []
      )
      when is_binary(access_token) and is_binary(subscription_id) and is_binary(operation_id) and
             is_binary(plan_id) and is_binary(quantity) and is_binary(status) do
    headers = [authorization_header(access_token) | headers]

    body =
      Jason.encode!(%{
        "planId" => plan_id,
        "quantity" => quantity,
        "status" => status
      })

    API.patch(
      "/subscriptions/#{subscription_id}/operations/#{operation_id}",
      body,
      headers,
      options
    )
  end

  @doc false
  def authorization_header(access_token) do
    {"authorization", "Bearer " <> access_token}
  end
end
