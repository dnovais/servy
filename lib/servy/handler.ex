defmodule Servy.Handler do
  @moduledoc """
  The Handler module with the responsibility to make transformation in an request
  and get the response
  """

  @doc """
  Start the function to handle...
  """
  def handle(request) do
    request
    |> parse()
    |> route()
    |> format_response()
  end

  @doc """
  The function parse get the request, extract the first line,
  split the first line with empty space and complete the map
  with informations about request
  """
  def parse(request) do
    [method, path, _version] =
      request
      |> String.split("\n")
      |> List.first()
      |> String.split(" ")

    %{method: method, path: path, response_body: ""}
  end

  @doc """
  Start the route function doc here
  """
  def route(_conversation) do
    # TODO: Create a new map that also has the response body:
    %{method: "GET", path: "/wildthings", response_body: "Bears, Lions, Tigers"}
  end

  @doc """
  Start the format_response function doc here
  """
  def format_response(_conversation) do
    # TODO: Use the values in the map to create an HTTP response string
    """
    HTTP/1.1 200 OK
    Content-Type: text/html
    Content-Length: 20

    Bears, Lions, Tigers
    """
  end
end

# HTTP request - Heredoc Elixir (3 double quote in beggining and in the end of block)
# GET (verb of request)
# /wildthings (path of request)
# HTTP/1.1 (the protocol from request)
# Host (where it request goes to)
# User-Agent (which browser the request came from)
# Accept (with wildcard indicates that the request accept any type of request)
# after a break line
# An optional body, that we can put the form params from a post request for example
request = """
GET /wildthings HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

# HTTP response - Heredoc Elixir (3 double quote in beggining and in the of block)
# HTTP/1.1 (The protocol of response)
# 200 (status code of response)
# OK (reason of response)
# Content-Type: (type of response, in this case text/html)
# Content-Length: (the length of the body in response)
# after a break line
# The body of response (content of body)
# _expected_response = """
# HTTP/1.1 200 OK
# Content-Type: text/html
# Content-Length: 20

# Bears, Lions, Tigers
# """

IO.inspect(Servy.Handler.handle(request))
