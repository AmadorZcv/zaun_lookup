defmodule ZaunLookup.Tracker do
  use GenServer
  import Ecto.Query, warn: false
  alias ZaunLookup.Players.{User}
  alias ZaunLookup.Riot
  alias ZaunLookup.Repo
  alias ZaunLookup.Riot.Endpoints
  @regions Enum.map(Endpoints.regions(), &%{region: &1, requests: 100})
  def start_link(opts) do
    GenServer.start_link(__MODULE__, %{}, opts)
  end

  def player_region(region) do
    requests =
      User
      |> order_by([u], fragment("?::time", u.updated_at))
      |> where([u], u.region == ^region[:region])
      |> where([u], is_nil(u.account_id))
      |> limit(^region[:requests])
      |> Repo.all()
      |> Enum.map(&Riot.set_user(region[:region], &1))
      |> Enum.count()

    Map.update!(region, :requests, &(&1 - requests))
  end

  def player_cycle(regions) do
    Task.async_stream(regions, &player_region(&1),
      timeout: 600_000,
      max_concurrency: 12
    )
    |> Enum.to_list()
  end

  def init(state) do
    # Schedule work to be performed at some point
    Riot.set_tops_of_regions(@regions)
    schedule_work()
    {:ok, state}
  end

  def handle_info(:work, state) do
    IO.puts("Player Cycle")

    @regions
    |> player_cycle()

    # Do the work you desire here
    # Reschedule once more
    schedule_work()
    {:noreply, state}
  end

  defp schedule_work() do
    # In 2 minutes and change
    Process.send_after(self(), :work, 120_001)
  end
end
