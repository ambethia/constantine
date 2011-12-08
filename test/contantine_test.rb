require "minitest/unit"
require "minitest/autorun"
require "active_support"
require "active_support/core_ext/string"

require "constantine"

class ContantineTest < MiniTest::Unit::TestCase

  def test_vanilla_constantization
    define "AlphaBravo" do
      assert_equal AlphaBravo, Constantine.constantize("AlphaBravo")
    end
  end

  def test_vanilla_nested_constantization
    define "Alpha::Bravo" do
      assert_equal Alpha::Bravo, Constantine.constantize("Alpha::Bravo")
    end
  end

  def test_nested_constantization
    define "Alpha::Bravo" do
      assert_equal Alpha::Bravo, Constantine.constantize("AlphaBravo")
    end
  end

  def test_nested_constantization_variation_one
    define "Alpha::BravoCharlie" do
      assert_equal Alpha::BravoCharlie, Constantine.constantize("AlphaBravoCharlie")
    end
  end

  def test_nested_constantization_variation_two
    define "AlphaBravo::Charlie" do
      assert_equal AlphaBravo::Charlie,
        Constantine.constantize("AlphaBravoCharlie")
    end
  end

  def test_nested_constantization_variation_three
    define "Alpha::Bravo::Charlie" do
      assert_equal Alpha::Bravo::Charlie,
        Constantine.constantize("AlphaBravoCharlie")
    end
  end

  def test_nested_constantization_variation_four
    define "Alpha::Bravo::Charlie" do
      assert_equal Alpha::Bravo::Charlie,
        Constantine.constantize("Alpha::BravoCharlie")
    end
  end

  def test_nested_constantization_on_needlessly_lengthy_variation
    define "Alpha::BravoCharlie::Delta::EchoFoxtrot" do
      assert_equal Alpha::BravoCharlie::Delta::EchoFoxtrot,
        Constantine.constantize("AlphaBravoCharlieDeltaEchoFoxtrot")
    end
  end

  def test_raises_name_error_on_missing_constant
    assert_raises NameError do
      Constantine.constantize("Alpha::Bravo")
    end
  end

  def test_define_helper_defines_constant
    define "AlphaBravo" do
      assert AlphaBravo
    end
  end

  def test_define_helper_undefines_constant
    define "AlphaBravo" do
    end
    refute Object.const_defined? "AlphaBravo"
  end

  def test_define_helper_defines_nested_constant
    define "Alpha::Bravo" do
      assert Alpha::Bravo
    end
  end

  def test_define_helper_undefines_nested_constant
    define "Alpha::Bravo" do
    end
    refute Object.const_defined? "Alpha"
  end

  def test_magic
    define "Alpha::Bravo" do
      assert_raises NameError do
        "AlphaBravo".constantize
      end
      ActiveSupport::Inflector.send :extend, Constantine::Support
      assert_equal Alpha::Bravo, "AlphaBravo".constantize
    end
  end

  def test_reasonable_constant_missing
    define "Alpha::Bravo" do
      exception = assert_raises NameError do
        Constantine.constantize("::Alpha::BravoCharlie")
      end
      assert_match /Alpha::BravoCharlie/, exception.message
    end
  end

  private

  def define(full_name)
    modules = full_name.split("::")
    modules.inject(Object) do |klass, name|
      klass.const_set(name, Module.new)
      yield if name == modules.last
      klass.const_get(name)
    end
    Object.send(:remove_const, modules.first)
  end
end
