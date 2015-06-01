# Created by Dr.Thunder on 5/31/15
# Copyright (c) 2015 Trace Norris. All rights reserved.
#
# This is version of a my Stochastic Agent model of STI infection in discrete populations.
# This is a rewrite from some C++ code. I'm rewriting it in crystal to familiarize myself
# with the language, as well as to revisit this code, and enjoy rewriting it in "ruby" my 
# preffered language.

class Agent

  getter gender

  def initialize(id)
    @id_num = id
    @mating_threshold = 0
    @gender = "lady"
    @infected = false
    @sexuality ="gay"
  end

  def id_num
    @id_num
  end

  def mating_threshold
    @mating_threshold
  end

  def gender
    @gender
  end

  def gender=(@gender)
  end

  def infected
    @infected
  end

  def sexuality
    @sexuality
  end

end



agents = 0 #number of people in the population
simulation_runs = 0 #how many times the simulation runs
starting_sick = 0 #number of sick people at the start
transmission_probability = 0.64 #sets the probability of individual getting the disease if they mate.
mating_threshold = 0.6 #Likely hood that a given pair mate, combined mating score needs to beat this threshold
save_previous_state = false #the infected from the previous generation informs the current generation.
GenderRatio = 0 #ladies to men


p1 =  Agent.new 1

puts p1.gender

p1.gender = "man"

puts p1.gender



