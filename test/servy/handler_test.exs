defmodule Servy.HandlerTest do
  use ExUnit.Case

  alias Servy.Handler

  doctest Servy

  describe "when servy got request and response with success" do
    test "parse/1 with success" do
      request = """
      GET /bears HTTP/1.1
      Host: example.com
      User-Agent: ExampleBrowser/1.0
      Accept: */*

      """

      assert request_parsed = Handler.parse(request)

      assert %{
               method: _method,
               path: _path,
               response_body: _response_body,
               status: _status
             } = request_parsed
    end
  end
end
