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
    |> parse
    |> log
    |> route
    |> format_response
  end

  @doc """
  The function show a log of request
  """
  def log(request), do: IO.inspect(request)

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

    %{
      method: method,
      path: path,
      response_body: "",
      status: nil
    }
  end

  @doc """
  This function gets the conversation and adds response_body content to the conversation map.
  """
  def route(conversation) do
    route(conversation, conversation.method, conversation.path)
  end

  def route(conversation, "GET", "/wildthings") do
    %{conversation | status: 200, response_body: "Bears, Lions, Tigers"}
  end

  def route(conversation, "GET", "/bears") do
    %{conversation | status: 200, response_body: "Teddy, Smokey, Paddington"}
  end

  def route(conversation, "GET", "/bears/" <> id) do
    %{conversation | status: 200, response_body: "Bear #{id}"}
  end

  def route(conversation, "DELETE", "/bears/" <> _id) do
    %{conversation | status: 403, response_body: "Deleting a bear..."}
  end

  def route(conversation, _method, path) do
    %{conversation | status: 404, response_body: "No #{path} here!"}
  end

  @doc """
  This function gest the conversation and format de response with HTTP response string
  """
  def format_response(conversation) do
    """
    HTTP/1.1 #{conversation.status} #{status_reason(conversation.status)}
    Content-Type: text/html
    Content-Length: #{String.length(conversation.response_body)}

    #{conversation.response_body}
    """
  end

  defp status_reason(code) do
    %{
      200 => "OK",
      201 => "Created",
      401 => "Unauthorized",
      403 => "Forbidden",
      404 => "Not Found",
      500 => "Internal Error"
    }[code]
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
DELETE /bears/1 HTTP/1.1
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
