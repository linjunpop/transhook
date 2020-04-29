defmodule Transhook.Webhook do
  @moduledoc """
  The Webhook context.
  """

  import Ecto.Query, warn: false
  alias Transhook.Repo

  alias Transhook.Webhook.Hook

  @doc """
  Returns the list of hooks.

  ## Examples

      iex> list_hooks()
      [%Hook{}, ...]

  """
  def list_hooks do
    Repo.all(Hook)
  end

  @doc """
  Gets a single hook.

  Raises `Ecto.NoResultsError` if the Hook does not exist.

  ## Examples

      iex> get_hook!(123)
      %Hook{}

      iex> get_hook!(456)
      ** (Ecto.NoResultsError)

  """
  def get_hook!(id), do: Repo.get!(Hook, id)

  @doc """
  Creates a hook.

  ## Examples

      iex> create_hook(%{field: value})
      {:ok, %Hook{}}

      iex> create_hook(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_hook(attrs \\ %{}) do
    %Hook{}
    |> Hook.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a hook.

  ## Examples

      iex> update_hook(hook, %{field: new_value})
      {:ok, %Hook{}}

      iex> update_hook(hook, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_hook(%Hook{} = hook, attrs) do
    hook
    |> Hook.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a hook.

  ## Examples

      iex> delete_hook(hook)
      {:ok, %Hook{}}

      iex> delete_hook(hook)
      {:error, %Ecto.Changeset{}}

  """
  def delete_hook(%Hook{} = hook) do
    Repo.delete(hook)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking hook changes.

  ## Examples

      iex> change_hook(hook)
      %Ecto.Changeset{data: %Hook{}}

  """
  def change_hook(%Hook{} = hook, attrs \\ %{}) do
    Hook.changeset(hook, attrs)
  end
end
