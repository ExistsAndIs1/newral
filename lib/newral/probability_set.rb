module Newral

  class ProbabilitySet
    attr_reader :history
    def initialize(  )
      @probabilities={}
      @history = []
    end

    def []( key )
      @probabilities[ key ] || ( @probabilities[key] = compute(key))
    end

    def set( key, set_value )
      @probabilities[ key ] = set_value
    end

    def multiply( key,other_key, set_value: nil )
      computed_key_name = "#{key}*#{other_key}"
      return @probabilities[computed_key_name] if @probabilities[ computed_key_name ] &&set_value.nil?
      set_value ||= compute( key )*compute( other_key )
      set( computed_key_name, set_value )
    end

    def divide( key,other_key, set_value: nil )
      computed_key_name = "#{key}/#{other_key}"
      return @probabilities[ computed_key_name ] if @probabilities[ computed_key_name] &&set_value.nil?
      set_value ||= compute( key )*compute( other_key )
      set( computed_key_name, set_value )
    end

    def not( key, set_value: nil )
      computed_key_name = "!#{key}"
      return @probabilities[ computed_key_name ] if @probabilities[computed_key_name ] &&set_value.nil?
      set_value ||= 1-compute( key )
      set( computed_key_name, set_value )
    end 

    def add( key,other_key, set_value: nil )
      computed_key_name = "#{key}+#{other_key}"
      return @probabilities[ computed_key_name] if @probabilities[ computed_key_name ] && set_value.nil?
      set_value ||= compute( key )+compute( other_key )
      set( computed_key_name, set_value )
    end
    # aposteriori =( Likelihood * Prior )/ marginal likelihood
    # P(A|B) = P(B|A)*P(A)/P(B)
    def aposteriori( key,apriori:nil, set_value: nil )
      computed_key_name = "#{key}|#{apriori}"
      return @probabilities[ computed_key_name ] if @probabilities[ computed_key_name ] &&set_value.nil?
      set_value ||= compute("#{apriori}|#{key}")*compute(key)/compute(apriori)
     set( computed_key_name, set_value )
    end


    def total( key, apriori: nil )
      aposteriori(key,apriori: apriori)*compute(apriori)+self.aposteriori(key,apriori: "!#{apriori}")*self.not(apriori)
    end 


    def and( key,other_key, set_value: nil )
      computed_key_name = "#{key}^#{other_key}"
      return @probabilities[computed_key_name ] if @probabilities[ computed_key_name ] &&set_value.nil?
      set_value ||= compute("#{key}|#{other_key}")*compute(other_key)
      set( computed_key_name, set_value )
    end

    def or(  key,other_key, set_value: nil )
      computed_key_name = "#{key}.#{other_key}"
      return @probabilities[ computed_key_name ] if @probabilities[computed_key_name] &&set_value.nil?
      set_value ||= compute(key)+compute(other_key)-compute("#{key}^#{other_key}")
      set( computed_key_name, set_value )
    end

    # P(R|H,S) = P(H|R,S)*P(R|S)/P(H|S)
    # P(R|H,!S) = P(H|R,!S)*P(R|!S)/P(H|!S)
    # 0.9*0.01/(0.9*0.01+0.1*0.99)
    # P(R|H) = P(H|R)*P(R)/P(H) = 0.9*0.01/  =0.097*0.01
    # P(H) = P  0.5244999999999999

      def compute( key )
        probability = if @probabilities[key]
          @probabilities[key]
        elsif key.start_with?("!") && @probabilities[key.sub("!","")]
          self.not(key.sub("!",''))
        elsif key.match('\|')
          @history << key unless @history.member?( key )
          key,apriori=key.split("|")
          self.aposteriori( key, apriori: apriori)
        elsif key.match('\^')
          @history << key unless @history.member?( key )
          key,other_key=key.split("^")
          self.and(key,other_key)
        else
          apriori_key = @probabilities.keys.find{|p| p.split("|")[0]==key && !p.split("|")[1].match('!') }
          if apriori_key
            @history << key unless @history.member?( key )
            apriori_key = apriori_key.split("|")[1]
            value = self.total(key,apriori: apriori_key)
            self.set( key, value)
          else 
            raise "not found #{key}"
          end
        end
        probability
      end
  end 

end