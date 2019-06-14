defmodule ZaunLookup.Riot.Structs.Region do
  @enforce_keys [:region]
  defstruct([:region, requests: 100])
end
