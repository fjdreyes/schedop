defmodule Schedop.TermsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Schedop.Terms` context.
  """

  @doc """
  Generate a term.
  """
  def term_fixture(attrs \\ %{}) do
    {:ok, term} =
      attrs
      |> Enum.into(%{
        name: "some name",
        uid: 42
      })
      |> Schedop.Terms.create_term()

    term
  end
end
