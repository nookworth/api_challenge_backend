defmodule Functions do
  use Agent
  use Tesla

  @locations %{slc: "Salt_Lake_City", la: "Los_Angeles", boise: "43.6150,-116.2023"}

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
    loc_string = String.replace(loc, "_", " ")
    url = url_constructor(loc)

    {:ok, %{status: 200, body: body}} = Tesla.get(url)
    {:ok, decoded} = Jason.decode(body)

    forecast = Map.get(decoded, "forecast")
    forecastday = Map.get(forecast, "forecastday")
    day_1 = List.first(forecastday)
    day_2 = Enum.at(forecastday, 1, "NOPE@1")
    day_3 = Enum.at(forecastday, 2, "NOPE@2")
    day_1_cond = Map.get(day_1, "day")
    day_2_cond = Map.get(day_2, "day")
    day_3_cond = Map.get(day_3, "day")
    day_1_max_temp = Map.get(day_1_cond, "maxtemp_f")
    day_2_max_temp = Map.get(day_2_cond, "maxtemp_f")
    day_3_max_temp = Map.get(day_3_cond, "maxtemp_f")
    temp_avg = (day_1_max_temp + day_2_max_temp + day_3_max_temp)/3

    # IO.puts("The average max temperature over the next three days in " <> loc_string <> " is " <> Float.to_string(temp_avg) <> " degrees Fahrenheit.")
    IO.puts(loc_string <> " Average Max Temp: " <> Float.to_string(temp_avg))
    Agent.update(agent, fn list -> [decoded|list] end)
  end

  # @spec multi_call(locations :: %{:slc :: String.to(), :la :: String.to(), :boise :: String.to()}) :: String.to()
  def multi_call() do
    {slc, la, boise} = setup()
    # locations = @locations
    # for pid <- pids, location <- locations, do: api_call(pid, location)
    api_call(slc, "Salt_Lake_City")
    api_call(la, "Los_Angeles")
    api_call(boise, "43.6150,-116.2023")
  end
end
