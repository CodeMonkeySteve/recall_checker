# Checks validity of a VIN according to the check digit
# Based on this: https://en.wikibooks.org/wiki/Vehicle_Identification_Numbers_%28VIN_codes%29/Check_digit
# Usage: ValidateVIN::valid?(vin)

module RecallChecker
  class VINValidator

    CODES = { "A" => "1",  "B" => "2",  "C" => "3",  "D" => "4",  "E" => "5",  "F" => "6",  
              "G" => "7",  "H" => "8",  "J" => "1",  "K" => "2",  "L" => "3",  "M" => "4",  
              "N" => "5",  "P" => "7",  "R" => "9",  "S" => "2",  "T" => "3",  "U" => "4",  
              "V" => "5",  "W" => "6",  "X" => "7",  "Y" => "8",  "Z" => "9" }

    WEIGHTS = [8, 7, 6, 5, 4, 3, 2, 10, 0, 9, 8, 7, 6, 5, 4, 3, 2]

    def self.format_valid? vin_arg
      vin = vin_arg.upcase
      vin.length == 17 && !vin.include?("I") && !vin.include?("O") && !vin.include?("Q")
    end

    def self.check_digit_valid? vin_arg
      vin = vin_arg.upcase
      weight = 0
      vin.each_char.with_index do |c, i|
        weight += CODES.fetch(c,c).to_i * WEIGHTS[i]
      end
      check_digit = (vin[8] == "X" ? 10 : vin[8].to_i)
      check_digit == weight % 11
    end

    def self.vin_valid? vin_arg
      self.format_valid?(vin_arg) && self.check_digit_valid?(vin_arg)
    end

  end
end
