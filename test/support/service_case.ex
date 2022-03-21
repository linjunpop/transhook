defmodule Transhook.ServiceCase do
  @moduledoc """
  This module defines the setup for tests requiring
  access to the application's service layer.

  """

  use ExUnit.CaseTemplate

  using do
    quote do
    end
  end

  setup _tags do
    :ok
  end
end
