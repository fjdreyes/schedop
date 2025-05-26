defmodule Schedop.TermsTest do
  use Schedop.DataCase

  alias Schedop.Terms

  describe "terms" do
    alias Schedop.Terms.Term

    import Schedop.TermsFixtures

    @invalid_attrs %{name: nil, uid: nil}

    test "list_terms/0 returns all terms" do
      term = term_fixture()
      assert Terms.list_terms() == [term]
    end

    test "get_term!/1 returns the term with given id" do
      term = term_fixture()
      assert Terms.get_term!(term.id) == term
    end

    test "create_term/1 with valid data creates a term" do
      valid_attrs = %{name: "some name", uid: 42}

      assert {:ok, %Term{} = term} = Terms.create_term(valid_attrs)
      assert term.name == "some name"
      assert term.uid == 42
    end

    test "create_term/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Terms.create_term(@invalid_attrs)
    end

    test "update_term/2 with valid data updates the term" do
      term = term_fixture()
      update_attrs = %{name: "some updated name", uid: 43}

      assert {:ok, %Term{} = term} = Terms.update_term(term, update_attrs)
      assert term.name == "some updated name"
      assert term.uid == 43
    end

    test "update_term/2 with invalid data returns error changeset" do
      term = term_fixture()
      assert {:error, %Ecto.Changeset{}} = Terms.update_term(term, @invalid_attrs)
      assert term == Terms.get_term!(term.id)
    end

    test "delete_term/1 deletes the term" do
      term = term_fixture()
      assert {:ok, %Term{}} = Terms.delete_term(term)
      assert_raise Ecto.NoResultsError, fn -> Terms.get_term!(term.id) end
    end

    test "change_term/1 returns a term changeset" do
      term = term_fixture()
      assert %Ecto.Changeset{} = Terms.change_term(term)
    end
  end
end
