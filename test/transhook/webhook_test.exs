defmodule Transhook.WebhookTest do
  use Transhook.DataCase

  alias Transhook.Webhook

  describe "hooks" do
    alias Transhook.Webhook.Hook

    @valid_attrs %{dispatcher: %{}, endpoint: "some endpoint", responder: %{}, trans_template: "some trans_template"}
    @update_attrs %{dispatcher: %{}, endpoint: "some updated endpoint", responder: %{}, trans_template: "some updated trans_template"}
    @invalid_attrs %{dispatcher: nil, endpoint: nil, responder: nil, trans_template: nil}

    def hook_fixture(attrs \\ %{}) do
      {:ok, hook} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Webhook.create_hook()

      hook
    end

    test "list_hooks/0 returns all hooks" do
      hook = hook_fixture()
      assert Webhook.list_hooks() == [hook]
    end

    test "get_hook!/1 returns the hook with given id" do
      hook = hook_fixture()
      assert Webhook.get_hook!(hook.id) == hook
    end

    test "create_hook/1 with valid data creates a hook" do
      assert {:ok, %Hook{} = hook} = Webhook.create_hook(@valid_attrs)
      assert hook.dispatcher == %{}
      assert hook.endpoint == "some endpoint"
      assert hook.responder == %{}
      assert hook.trans_template == "some trans_template"
    end

    test "create_hook/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Webhook.create_hook(@invalid_attrs)
    end

    test "update_hook/2 with valid data updates the hook" do
      hook = hook_fixture()
      assert {:ok, %Hook{} = hook} = Webhook.update_hook(hook, @update_attrs)
      assert hook.dispatcher == %{}
      assert hook.endpoint == "some updated endpoint"
      assert hook.responder == %{}
      assert hook.trans_template == "some updated trans_template"
    end

    test "update_hook/2 with invalid data returns error changeset" do
      hook = hook_fixture()
      assert {:error, %Ecto.Changeset{}} = Webhook.update_hook(hook, @invalid_attrs)
      assert hook == Webhook.get_hook!(hook.id)
    end

    test "delete_hook/1 deletes the hook" do
      hook = hook_fixture()
      assert {:ok, %Hook{}} = Webhook.delete_hook(hook)
      assert_raise Ecto.NoResultsError, fn -> Webhook.get_hook!(hook.id) end
    end

    test "change_hook/1 returns a hook changeset" do
      hook = hook_fixture()
      assert %Ecto.Changeset{} = Webhook.change_hook(hook)
    end
  end
end
