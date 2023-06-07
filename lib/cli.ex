defmodule Cli do
  import Functions

  loc_map = %{slc: "Salt_Lake_City", la: "Los_Angeles", boise: "43.6150,-116.2023"}

  Functions.setup()

  user_var = IO.gets("Choose slc, la, or boise: ")
  IO.puts("You selected: " <> user_var)

  String.to_atom(user_var)

  loc_string = Map.get(loc_map, user_var)
  # IO.puts("Your selection was mapped to: " <> loc_string)
  IO.puts(loc_string)

  # Functions.api_call(user_var, loc_string)
end
