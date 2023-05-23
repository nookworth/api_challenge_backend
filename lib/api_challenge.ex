defmodule ApiChallenge do
  use Agent
  use HTTPoison.Base
  @derive [Poison.Parser]


  def setup do
    {:ok, slc} = Agent.start(fn -> [] end)
    {:ok, la} = Agent.start(fn -> [] end)
    {:ok, boise} = Agent.start(fn -> [] end)
    {slc, la, boise}
  end

  def url_constructor(location) do
    "http://api.weatherapi.com/v1/forecast.json?key=7514621f9a034b1b9a1170939231805&q=" <>
      location <> "&days=6&aqi=no&alerts=no"
  end

  slc_loc = "Salt_Lake_City"
  la_loc = "Los_Angeles"
  boise_loc = "43.6150,-116.2023"

  def agent_func(url) do
    # define functions to be used in Agent.update
    response = HTTPoison.get(url)
    response
  end

  def api_call(agent, loc) do
    url = url_constructor(loc)
    response = HTTPoison.get(url)
    # json_response = Poison.Parser.parse!(response)
    Agent.get_and_update(agent, fn list -> {list, list ++ response} end)
  end
end
