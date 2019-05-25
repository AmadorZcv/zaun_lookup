defmodule ZaunLookup.Tracker do
  use GenServer
  import Ecto.Query, warn: false
  alias ZaunLookup.Players.{User}
  alias ZaunLookup.Riot
  alias ZaunLookup.Repo
  alias ZaunLookup.Riot.Endpoints

  def start_link(opts) do
    GenServer.start_link(__MODULE__, %{}, opts)
  end

  def player_region(region, requests) do
    User
    |> order_by([u], fragment("?::time", u.updated_at))
    |> where([u], u.region == ^region)
    |> where([u], is_nil(u.account_id))
    |> limit(^requests)
    |> Repo.all()
    |> Enum.each(&Riot.set_user(region, &1))
  end

  def player_cycle(requests) do
    Task.async_stream(Endpoints.regions(), &player_region(&1, requests),
      timeout: 600_000,
      max_concurrency: 12
    )
    |> Enum.to_list()
  end

  def init(state) do
    Riot.set_tops_of_regions()
    # Schedule work to be performed at some point
    schedule_work()
    {:ok, state}
  end

  def handle_info(:work, state) do
    IO.puts("Player Cycle")
    player_cycle(100)

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
