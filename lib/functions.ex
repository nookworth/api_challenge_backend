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

  def api_call(loc) do
    # loc_string = String.replace(loc, "_", " ")
    url = url_constructor(loc)

    {:ok, %{status: 200, body: body}} = Tesla.get(url)
    {:ok, decoded} = Jason.decode(body)

    for forecastday <- decoded["forecast"]["forecastday"] do
          forecastday["day"]["maxtemp_f"]
        end
        |> Enum.sum()
        |> Kernel./(3)
        |> Float.floor(2)
        # |> IO.inspect()

    # IO.puts("The average max temperature over the next three days in " <> loc_string <> " is " <> Float.to_string(temp_avg) <> " degrees Fahrenheit.")
    # IO.puts(loc_string <> " Average Max Temp: " <> Float.to_string(temp_avg))
    # Agent.update(agent, fn list -> [decoded|list] end)
  end

  # @spec multi_call(locations :: %{:slc :: String.to(), :la :: String.to(), :boise :: String.to()}) :: String.to()
  def multi_call() do
    # {slc, la, boise} = setup()
    # # locations = @locations
    # # for pid <- pids, location <- locations, do: api_call(pid, location)
    # api_call(slc, "Salt_Lake_City")
    # api_call(la, "Los_Angeles")
    # api_call(boise, "43.6150,-116.2023")

    tasks = Enum.map(@locations, fn {_key, location} ->
      Task.async(fn -> api_call(location) end)
    end)

    Enum.map(tasks, &Task.await/1)
  end
end
