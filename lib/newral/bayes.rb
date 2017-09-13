module Newral
  
  class Bayes
    attr_reader :theorem, :probabilities
    def initialize( theorem )
      @theorem = theorem
      @probabilities = {}
    end 

    def add_probability(key,probability,apriori: nil)
      probability = Probability.new(key,probability,apriori: apriori)
      @probabilities[ probability.key ] = probability 
    end

    def compute( key )
      probability = if @probabilities[key]
        @probabilities[key]
      elsif key.start_with?("!") && @probabilities[key.sub("!","")]
        !@probabilities[key.sub("!",'')]
      elsif key.match('\|')
        key,apriori=key.split("|")
        compute("#{apriori}|#{key}")*compute(key)/compute(apriori)
      else
        apriori = @probabilities.keys.find{|p| p.split("|")[0]==key && !p.split("|")[1].match('!') }
        if apriori
          apriori = apriori.split("|")[1]
          compute("#{key}|#{apriori}")*compute(apriori)+compute("#{key}|!#{apriori}")*compute("!#{apriori}")
        else 
          puts "not found #{key}"
        end
      end
      @probabilities[ probability.key ] = probability
      probability
    end

  end


end