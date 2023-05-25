defmodule ApiChallenge do
  use Agent
  use Tesla

  plug Tesla.Middleware.JSON

  def setup do
    {:ok, slc} = Agent.start(fn -> [] end)
    {:ok, la} = Agent.start(fn -> [] end)
    {:ok, boise} = Agent.start(fn -> [] end)
    {slc, la, boise}
  end

  def url_constructor(location) do
    "http://api.weatherapi.com/v1/forecast.json?key=7514621f9a034b1b9a1170939231805&q=" <> location <> "&days=6&aqi=no&alerts=no"
  end

  def api_call(agent, loc) do
    url = url_constructor(loc)

    {:ok, %{status: 200, body: body}} = Tesla.get(url)
    {:ok, %{status: "OK", results: results}} = Jason.decode(body)
    IO.puts("Constructed URL: " <> url)

    Agent.update(agent, fn list -> [results|list] end)
  end
end
