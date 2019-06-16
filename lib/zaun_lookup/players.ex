defmodule ZaunLookup.Players do
  @moduledoc """
  The Players context.
  """

  import Ecto.Query, warn: false
  alias ZaunLookup.Repo
  alias ZaunLookup.Riot.Structs.{UserFromLeague, UserFromMatch, UserFromMatchDetail}
  alias ZaunLookup.Players.User

  @topic inspect(__MODULE__)

  def subscribe do
    Phoenix.PubSub.subscribe(ZaunLookup.PubSub, @topic)
  end

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    User
    |> order_by(asc: :region)
    |> order_by(desc: :points)
    |> Repo.all()
  end

  def list_users_to_update(region) do
    User
    |> order_by([u], fragment("?::time", u.updated_at))
    |> where([u], u.region == ^region.region)
    |> where([u], is_nil(u.account_id))
    |> limit(^region.requests)
    |> Repo.all()
  end

  def count_players() do
    User
    |> Repo.aggregate(:count, :id)
  end

  def list_users_matches_to_update(region) do
    User
    |> order_by([u], fragment("?::time", u.updated_at))
    |> where([u], u.region == ^region.region)
    |> where([u], not is_nil(u.account_id))
    |> limit(^region.requests)
    |> Repo.all()
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
    |> notify_subscribers([:player, :created])
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
    |> notify_subscribers([:player, :updated])
  end

  @doc """
  Deletes a User.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  def update_from_match_list(player, match) do
    if Enum.count(match["matches"]) == 0 do
      player
      |> update_user(%{begin_index: 0})
    else
      player
      |> update_user(%{begin_index: match["endIndex"]})
    end
  end

  def user_struct_from_summoner(user, region) do
    %{
      name: user["name"],
      riot_id: user["id"],
      last_updated: Time.utc_now() |> Time.truncate(:second),
      region: region,
      account_id: user["accountId"],
      puuid: user["puuid"],
      begin_index: 0
    }
  end

  def create_user_from_league(user, region) do
    UserFromLeague.from_api(user, region)
    |> create_user()
  end

  def update_user_from_league(updated, region, user) do
    updated_user = UserFromLeague.from_api(updated, region)
    update_user(user, updated_user)
  end

  def update_user_from_summoner(updated, region, user) do
    updated_user = user_struct_from_summoner(updated, region)
    update_user(user, updated_user)
  end

  def insert_user_from_match(user, region) do
    UserFromMatchDetail.from_api(user, region)
    |> create_user()
  end

  def get_user_from_match(riot_id, region) do
    User
    |> where([u], not is_nil(u.riot_id))
    |> where([u], not is_nil(u.region))
    |> where([u], u.riot_id == ^riot_id)
    |> where([u], u.region == ^region)
    |> Repo.one()
  end

  def update_user_from_match(user, user_api, region) do
    updated_user = UserFromMatchDetail.from_api(user_api, region)
    update_user(user, updated_user)
  end

  def user_id_from_match(user) do
    original_user =
      User
      |> where([u], u.riot_id == ^user["summonerId"])
      |> where([u], u.region == ^user["platformId"])
      |> Repo.one()

    case original_user do
      nil ->
        UserFromMatch.from_api(user)
        |> create_user()

      original_user ->
        updated_user = UserFromMatch.from_api(user)
        update_user(original_user, updated_user)
    end
  end

  defp notify_subscribers({:ok, result}, event) do
    Phoenix.PubSub.broadcast(ZaunLookup.PubSub, @topic, {__MODULE__, event, result})

    Phoenix.PubSub.broadcast(
      ZaunLookup.PubSub,
      @topic <> "#{result.id}",
      {__MODULE__, event, result}
    )

    {:ok, result}
  end

  defp notify_subscribers({:error, reason}, _event), do: {:error, reason}
end
