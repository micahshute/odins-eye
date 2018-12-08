class RandomPasswordStrategy

    def self.random_password
        [ random_letter, random_letter.upcase, random_digit.to_s , random_hex(8), random_symbol ].shuffle.join("")
    end
    
    def self.random_hex(size)
        SecureRandom.hex(size)
    end
  
    def self.random_letter
        r = Random.new.rand(26)
        ("a".ord + r).chr
    end
    
    def self.random_digit
        Random.new.rand(10)
    end

    def self.random_symbol
        "!"
    end
end