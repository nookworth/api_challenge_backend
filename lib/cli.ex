# defmodule Cli do
  # import Functions

  # {slc, la, boise} = Functions.setup()
  # loc_map = %{"slc" => {slc, "Salt_Lake_City"}, "la" => {la, "Los_Angeles"}, "boise" => {boise, "43.6150,-116.2023"}}

  # user_var = IO.gets("Choose slc, la, or boise: ")
  # IO.puts("You selected: " <> user_var)

  # String.to_atom(user_var)

  # target = Map.get(loc_map, user_var) |> Tuple.to_list() |> List.to_string()
  # IO.puts(loc_string)
  # IO.puts("Your selection was mapped to: ", target)
  # IO.puts(loc_string)

  # Functions.api_call(user_var, loc_string)
# end
