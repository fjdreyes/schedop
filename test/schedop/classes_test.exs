defmodule Schedop.ClassesTest do
  use Schedop.DataCase

  alias Schedop.Classes

  describe "classes" do
    alias Schedop.Classes.Class

    import Schedop.ClassesFixtures

    @invalid_attrs %{code: nil, name: nil, description: nil, section: nil, units: nil, schedule: nil, instructor: nil, remarks: nil, department: nil, slots_total: nil, slots_available: nil, demand: nil, restrictions: nil}

    test "list_classes/0 returns all classes" do
      class = class_fixture()
      assert Classes.list_classes() == [class]
    end

    test "get_class!/1 returns the class with given id" do
      class = class_fixture()
      assert Classes.get_class!(class.id) == class
    end

    test "create_class/1 with valid data creates a class" do
      valid_attrs = %{code: 42, name: "some name", description: "some description", section: "some section", units: 42, schedule: "some schedule", instructor: "some instructor", remarks: "some remarks", department: "some department", slots_total: 42, slots_available: 42, demand: 42, restrictions: "some restrictions"}

      assert {:ok, %Class{} = class} = Classes.create_class(valid_attrs)
      assert class.code == 42
      assert class.name == "some name"
      assert class.description == "some description"
      assert class.section == "some section"
      assert class.units == 42
      assert class.schedule == "some schedule"
      assert class.instructor == "some instructor"
      assert class.remarks == "some remarks"
      assert class.department == "some department"
      assert class.slots_total == 42
      assert class.slots_available == 42
      assert class.demand == 42
      assert class.restrictions == "some restrictions"
    end

    test "create_class/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Classes.create_class(@invalid_attrs)
    end

    test "update_class/2 with valid data updates the class" do
      class = class_fixture()
      update_attrs = %{code: 43, name: "some updated name", description: "some updated description", section: "some updated section", units: 43, schedule: "some updated schedule", instructor: "some updated instructor", remarks: "some updated remarks", department: "some updated department", slots_total: 43, slots_available: 43, demand: 43, restrictions: "some updated restrictions"}

      assert {:ok, %Class{} = class} = Classes.update_class(class, update_attrs)
      assert class.code == 43
      assert class.name == "some updated name"
      assert class.description == "some updated description"
      assert class.section == "some updated section"
      assert class.units == 43
      assert class.schedule == "some updated schedule"
      assert class.instructor == "some updated instructor"
      assert class.remarks == "some updated remarks"
      assert class.department == "some updated department"
      assert class.slots_total == 43
      assert class.slots_available == 43
      assert class.demand == 43
      assert class.restrictions == "some updated restrictions"
    end

    test "update_class/2 with invalid data returns error changeset" do
      class = class_fixture()
      assert {:error, %Ecto.Changeset{}} = Classes.update_class(class, @invalid_attrs)
      assert class == Classes.get_class!(class.id)
    end

    test "delete_class/1 deletes the class" do
      class = class_fixture()
      assert {:ok, %Class{}} = Classes.delete_class(class)
      assert_raise Ecto.NoResultsError, fn -> Classes.get_class!(class.id) end
    end

    test "change_class/1 returns a class changeset" do
      class = class_fixture()
      assert %Ecto.Changeset{} = Classes.change_class(class)
    end
  end
end
