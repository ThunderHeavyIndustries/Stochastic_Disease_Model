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
save_previous_state = false #the infected from the previous generation informs the current generation.



def create_population population_size, starting_infected, gender_ratio

  population = [] of Agent #this is our array of agents from the agent class
  gender = "" #set based on gender ratio pass 4, then every 4th will be male

  (0..population_size-1).each do |n|

    if n % gender_ratio == 0
      gender = "male"
      puts "male"
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




def simulate_interaction population, mating_threshold, transmission_probability

  population.each do |person|

    population.each do |n_person|

      next if person.id == n_person.id

      if person.promiscuity + n_person.promiscuity >= mating_threshold

        if rand > transmission_probability

          if person.infected || n_person.infected

              person.infected  = true
              n_person.infected = true
          end
        end
      end
    end
  end
end



p = create_population 100, 5, 4

simulate_interaction p, 0.5, 0.3





# For speed checking purposes
puts "/////////////////////////////"
puts "runtime: #{ -(t_now - Time.now) }"