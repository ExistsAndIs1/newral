module Newral

  class Probability 
    attr_reader :key, :probability, :apriori
    def initialize( key, probability, apriori:nil )
      @key = key 
      @probability = probability
      @apriori = apriori
      @key = "#{key}|#{apriori}" if apriori
    end

    def *( other_probability )
      Probability.new("#{self.key}*#{other_probability.key}",self.probability*other_probability.probability)
    end

    def /( other_probability )
      Probability.new("#{self.key}/#{other_probability.key}",self.probability/other_probability.probability)
    end

    def !
      Probability.new("!#{key}",1-probability)
    end 

    def+(other_probability)
      Probability.new("#{self.key}+#{other_probability.key}",self.probability+other_probability.probability)
    end

    def apriori=( apriori: other_probability, probability: nil )
       Probability.new("#{self.key}|#{other_probability.key}",probability)
    end

    def and( other_probability )
      Probability.new("#{self.key}^#{other_probability.key}",self.probability*other_probability.probability)
    end

    def or( other_probability )
      Probability.new("#{self.key}*#{other_probability.key}",self.probability*other_probability.probability)
    end

  end 

end