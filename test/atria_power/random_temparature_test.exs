defmodule AtriaPower.RandomTemparatureTest do
  use ExUnit.Case

  describe "Testing generate/0" do
    test "generate a random float value" do
      random_one = AtriaPower.RandomTemparature.generate()
      random_two = AtriaPower.RandomTemparature.generate()

      assert random_one != random_two
    end
  end
end
