# Created by Dr.Thunder on 5/31/15
# Copyright (c) 2015 Trace Norris. All rights reserved.
#
# This is version of a my Stochastic Agent model of STI infection in discrete populations.
# This is a rewrite from some C++ code. I'm rewriting it in Crystal to familiarize myself
# with the language, as well as to revisit this code, and enjoy rewriting it in a more "ruby" way.
# Since Ruby is my preffered language.

# For speed checking purposes
t_now = Time.now

# This class defines the available information for individuals in the simulation
class Agent

  getter id

  getter promiscuity

  getter gender

  getter infected
  setter infected

  getter sexuality

  def initialize id, promiscuity, gender, infected, sexuality, when_infected 
    @id = id
    @promiscuity = promiscuity
    @gender = gender
    @infected = infected
    @sexuality = sexuality
    @when_infected = when_infected
  end

end


# set up the simulation
simulation_runs = 0 #how many times the simulation runs
transmission_probability = 0.64 #sets the probability of individual getting the disease if they mate.
mating_threshold = 0.6 #Likely hood that a given pair mate, combined mating score needs to beat this threshold (think of it as how conservative in it's sexual practices the society is at large)
save_previous_state = false #the infected from the previous generation informs the current generation.
gender_ratio =  0.4 # percentage of the population that is different from the other



def create_population population_size, starting_infected, gender_ratio

  population = [] of Agent #this is our array of agents from the agent class
  gender = ""


  (0..population_size-1).each do |n|

    if rand > gender_ratio
      gender = "male"
    else
      gender = "female"
    end

    if starting_infected>0

      agent = Agent.new n , rand, gender, true, "g", 0
      population.push(agent)
      starting_infected = starting_infected-1
    else

     agent = Agent.new n , rand, gender, false, "g", 0
     population.push(agent)
   end
  end
  return population
end


p = create_population 200, 5, 0.5

(0..25).each {|n| puts " #{p[n].id}, #{p[n].gender}, #{p[n].promiscuity}% , #{p[n].infected}" }


# For speed checking purposes
puts "runtime: #{ -(t_now - Time.now) }"

