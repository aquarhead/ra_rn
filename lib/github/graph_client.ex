defmodule RaRn.GraphClient do
  @moduledoc """
  Client for querying GitHub's GraphQL API.
  """
  use Tesla
  alias RaRn.ReleaseInfo

  @token Application.get_env(:ra_rn, :github_token)

  plug(Tesla.Middleware.Headers, [
    {"user-agent", "github.com/aquarhead/ra_rn"},
    {"authorization", "bearer #{@token}"}
  ])

  plug(Tesla.Middleware.JSON)
  plug(Tesla.Middleware.Retry, delay: 500, max_retries: 3)
  plug(Tesla.Middleware.BaseUrl, "https://api.github.com")

  @query_latest """
  {
    repository(owner: "<%= owner %>", name: "<%= name %>") {
      releases(first: 1, orderBy: {field: CREATED_AT, direction: DESC}) {
        edges{
          cursor
          node {
            tag {
              name
            }
            url
          }
        }
      }
    }
  }
  """

  @page_size 5
  @query_with_cursor """
  {
    repository(owner: "<%= owner %>", name: "<%= name %>") {
      releases(before: "<%= cursor %>", last: #{@page_size}, orderBy: {field: CREATED_AT, direction: DESC}) {
        edges{
          cursor
          node {
            tag {
              name
            }
            url
          }
        }
      }
    }
  }
  """

  def query_latest_release(owner, name) do
    doc = EEx.eval_string(@query_latest, owner: owner, name: name)
    query_body = Jason.encode!(%{query: doc})

    case post("/graphql", query_body) do
      {:ok, %Tesla.Env{status: 200, body: body}} ->
        latest_release =
          body["data"]["repository"]["releases"]["edges"] |> Enum.at(0) |> to_release_info()

      err ->
        err
    end
  end

  def query_new_releases(owner, name, cursor) do
    doc = EEx.eval_string(@query_with_cursor, owner: owner, name: name, cursor: cursor)
    query_body = Jason.encode!(%{query: doc})

    case post("/graphql", query_body) do
      {:ok, %Tesla.Env{status: 200, body: body}} ->
        new_releases =
          body["data"]["repository"]["releases"]["edges"] |> Enum.map(&to_release_info/1)

      err ->
        err
    end
  end

  # convert result from GitHub API to ReleaseInfo
  defp to_release_info(release_edge) do
    %ReleaseInfo{
      tag: release_edge["node"]["tag"]["name"],
      url: release_edge["node"]["url"],
      cursor: release_edge["cursor"]
    }
  end
end
