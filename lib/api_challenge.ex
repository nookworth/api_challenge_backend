defmodule ApiChallenge do
  use Agent
  use Tesla

  # plug Tesla.Middleware.JSON

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
    {:ok, decoded} = Jason.decode(body)
    # IO.puts("Constructed URL: " <> url)

    Agent.update(agent, fn list -> [decoded|list] end)
    # IO.puts(Map.get(decoded, :current, "Not present"))
    weather_map = decoded[0]
    IO.puts(weather_map)
    # IO.puts(Map.get(weather_map, :current, "still wrong"))
  end
end
