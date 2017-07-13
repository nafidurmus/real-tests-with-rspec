require 'money'
require 'monetize'

class String
  def is_i?
    !!(self =~ /^[-+]?[0-9]+$/)
  end
end

class Integer
  def is_i?
    true
  end
end

class MoneyHelper
  # Convert a fractional integer money to BigDecimal
  def self.money_to_decimal(value, currency = :try)
    value.fdiv(100).to_money(currency).amount
  end

  # Convert a fractional integer money to string representation of BigDecimal
  # May be used as a parameter for payment integration.
  def self.money_to_string_decimal(value, currency = :try)
    MoneyHelper.money_to_decimal(value, currency).to_s('F')
  end

  # Convert a fractional integer money to string
  # Respects locale settings for decimal mark.
  # May be used for display.
  # E.g: 1000 -> 10,00 (TRY)
  def self.money_to_string(value, currency = :try)
    value.fdiv(100).to_money(currency).to_s
  end

  # Convert a string representation to fractional integer money
  # E.g: "10,00" -> 1000
  def self.money_from_string(value, currency = :try)
    Monetize.parse(value, currency, :assume_from_symbol => false).fractional
  end

  # Format money. (Essentially void at the moment)
  def self.format_money(value, currency = :try)
    case value
    when nil
      0
    when Numeric
      value.to_i
    when String
      value.strip.to_i
    else
      value
    end
  end

  # Cleans string and returns money: " 1000 " -> 1000
  # Returns 0 for nil.
  def self.parse_money(value, currency = :try)
    case value
    when nil
      0
    when Numeric
      value.to_i
    when String
      value.strip.to_i
    end
  end

  # Validate money string in fractional integer format.
  # Returns true for valid input, false otherwise.
  def self.valid_money?(value)
    case value
    when Numeric
      true
    when String
      value.strip.is_i?
    else
      false
    end
  end
end
