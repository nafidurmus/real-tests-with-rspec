require_relative '../money_helper'
I18n.config.available_locales = :en

describe MoneyHelper do

  describe "money_to_decimal" do
    it "returns the value of kurus as try" do
      expect(MoneyHelper.money_to_decimal(1000)).to eq 10
      expect(MoneyHelper.money_to_decimal(100)).to eq 1
      expect(MoneyHelper.money_to_decimal(10)).to eq 0.1
      expect(MoneyHelper.money_to_decimal(1)).to eq 0.01
    end
  end

  describe "money_to_string_decimal" do
    it "should format to kurus" do
      expect(MoneyHelper.money_to_string_decimal(100,"TRY")).to eq "1.0"
      expect(MoneyHelper.money_to_string_decimal(10,"TRY")).to eq "0.1"
    end

    it "should preserve the precision" do
      expect(MoneyHelper.money_to_string_decimal(505,"TRY")).to eq "5.05"
      expect(MoneyHelper.money_to_string_decimal(4,"TRY")).to eq "0.04"
    end
  end

  describe "money_to_string" do # E.g: 1000 -> 10,00 (TRY)
    it "should convert kurus to a float" do
      expect(MoneyHelper.money_to_string(1000,"TRY")).to eq "10,00"
      expect(MoneyHelper.money_to_string(2000,"TRY")).to eq "20,00"
      expect(MoneyHelper.money_to_string(100,"TRY")).to eq "1,00"
    end
  end

  describe "money_from_string  " do # E.g: "10,00" -> 1000
    it "should preserve the precision ','" do
      expect(MoneyHelper.money_from_string("10,00", 'TRY')).to eq 1000
      expect(MoneyHelper.money_from_string("20,00", 'TRY')).to eq 2000
      expect(MoneyHelper.money_from_string("1,00", 'TRY')).to eq 100
      expect(MoneyHelper.money_from_string("0,01", 'TRY')).to eq 1
    end

    it "should preserve the precision '.' " do
      expect(MoneyHelper.money_from_string("5.75", 'TRY')).to eq 575
      expect(MoneyHelper.money_from_string("10.00", 'TRY')).to eq 1000
      expect(MoneyHelper.money_from_string("57.55", 'TRY')).to eq 5755
    end
  end

  describe "format_money" do
    it "strips whitespace from both sides of the string" do
      expect(MoneyHelper.format_money("  1231   ")).to eq 1231
      expect(MoneyHelper.format_money("  1564646465465465   ")).to eq 1564646465465465

    end
    it "strips whitespace from right side of the string" do
      expect(MoneyHelper.format_money("1231   ")).to eq 1231
    end
    it "strips whitespace from left side of the string" do
      expect(MoneyHelper.format_money("  1231")).to eq 1231
    end

    it "returns 0 if nil" do
      expect(MoneyHelper.format_money(nil)).to eq 0
    end

    it "returns the same value if object is unknown" do 
      expect(MoneyHelper.format_money("hello")).to eq 0
      expect(MoneyHelper.format_money(:hello)).to eq :hello
    end
  end

  describe "parse_money" do # " 1000 " -> 1000
    it "Cleans string and returns money" do
      expect(MoneyHelper.parse_money(" 1000 ")).to eq 1000
      expect(MoneyHelper.parse_money("    1000 ")).to eq 1000
      expect(MoneyHelper.parse_money(" 1000    ")).to eq 1000
      expect(MoneyHelper.parse_money(" 1000        ")).to eq 1000
      expect(MoneyHelper.parse_money("1000")).to eq 1000

      expect(MoneyHelper.parse_money("    1000 ")).to eq 1000
      expect(MoneyHelper.parse_money(" 1000    ")).to eq 1000
      expect(MoneyHelper.parse_money(" 1000        ")).to eq 1000
      expect(MoneyHelper.parse_money("1000")).to eq 1000

      expect(MoneyHelper.parse_money(" 200")).to eq 200
      expect(MoneyHelper.parse_money("  123   ")).to eq 123
    end

    it "returns 0 if string is empty" do
      expect(MoneyHelper.parse_money(nil)).to eq 0
    end

    it "return to numeric value " do
      expect(MoneyHelper.parse_money(1000)).to eq 1000
      expect(MoneyHelper.parse_money(223)).to eq 223
      expect(MoneyHelper.parse_money(1)).to eq 1
    end
  end

  describe "valid_money?" do
    it "returns the amount in fractional" do
      expect(MoneyHelper.valid_money?(1)).to be true
      expect(MoneyHelper.valid_money?(10)).to be true
      expect(MoneyHelper.valid_money?(15.00)).to be true
      expect(MoneyHelper.valid_money?(123)).to be true
      expect(MoneyHelper.valid_money?(3.99)).to be true
      expect(MoneyHelper.valid_money?(55)).to be true
      expect(MoneyHelper.valid_money?(+5)).to be true
    end

    it "returns the negative value for function" do
      expect(MoneyHelper.valid_money?(-5)).to be true
      expect(MoneyHelper.valid_money?("-5")).to be true
    end

    it "Validate money string in fractional integer format" do
      expect(MoneyHelper.valid_money?('hello')).to be false
      expect(MoneyHelper.valid_money?(' 1000 ')).to eq MoneyHelper.valid_money?(1000)
      expect(MoneyHelper.valid_money?('100')).to be true
      expect(MoneyHelper.valid_money?(" 200")).to be true
    end
  end
end
