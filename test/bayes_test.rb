
require 'test_helper'
include Newral
class  BayesTest < Minitest::Test


    #def test_simple
    #  b=Newral::Bayes.new "ai"
    #  b.add_probability("aids",0.002)
    #  b.add_probability("+",0.97,apriori:'aids')
    #  b.add_probability("+",0.01,apriori:"!aids")
    #  result = b.compute("aids|+")
    #  assert_equal 16,(result.probability*100).to_i
    # end 

    def test_set
      p=Newral::ProbabilitySet.new 
      p.set "aids",0.002
      p.aposteriori( "+",apriori: "aids", set_value: 0.97)
      p.aposteriori( "+",apriori: "!aids", set_value: 0.01)
      p.and("+","aids")
      result = p["aids|+"]
      assert_equal 16,(result*100).to_i
    end

    def test_cancer
      p=Newral::ProbabilitySet.new 
      p.set "cancer",0.008 # probability of cancer
      p.aposteriori( "+",apriori: "cancer", set_value: 0.98) # 0.98 probability of a positive test if you have cancer
      p.aposteriori( "-",apriori: "cancer", set_value: 0.02)  # 0.02 probability of a negative test if you have cancer
      p.aposteriori( "+",apriori: "!cancer", set_value: 0.03) # 0.03 probability of a positive test if you do not have cancer
      result = p.multiply("cancer|+",'!cancer')
      # p = 0.98*0.008+0.03*(1-0.008)
      # 0.98*0.008/p 
      # should be 20, need to check
      assert_equal 20,(result*100).to_i
    end

    def test_cancer_bayes
      p=Newral::ProbabilitySet.new 
      p.set "cancer",0.01
      p.aposteriori( "+",apriori: "cancer", set_value: 0.9)
      p.aposteriori( "!+",apriori: "!cancer", set_value: 0.9)
    end

    def test_cancer_bayes_two_tests
      p=Newral::ProbabilitySet.new 
      p.set "cancer",0.01
      p.aposteriori( "+",apriori: "cancer", set_value: 0.9)
      p.aposteriori( "!+",apriori: "!cancer", set_value: 0.8)
      #P(c|t1+ t2+) = p(t1+t2+|c)*p(c)/p(t1+,t2+) = 
      # p(t1+t2+|c)*p(c)/(p(t1+t2|c)+p(-t1-t2|c))
    end
    
end

