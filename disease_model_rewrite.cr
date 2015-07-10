# Created by Dr.Thunder on 5/31/15
# Copyright (c) 2015 Trace Norris. All rights reserved.
#
# This is version of a my Stochastic Agent model of STI infection in discrete populations.
# This is a rewrite from some C++ code. I'm rewriting it in Crystal to familiarize myself
# with the language, as well as to revisit this code, and enjoy rewriting it in a more "ruby" way.
# Since Ruby is my preffered language.

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

def create_population population_size, starting_infected, gender_ratio

  population = {} of Int32 => Agent #this is our hash of agents from the agent class
  gender = "" #set based on gender ratio, pass 4 then every 4th will be male

  (0...population_size).each do |n|

    if n % gender_ratio == 0
      gender = "male"
    else
      gender = "female"
    end

    if starting_infected>0

      agent = Agent.new n , rand, gender, true, "g", 0
      population[agent.id] = agent
      starting_infected = starting_infected-1

    else

     agent = Agent.new n , rand, gender, false, "g", 0
     population[agent.id] = agent
    end
  end
  return population
end



# same problem as last time, I'm updating the population real time, which exponentialy grows the infected population
def simulate_interaction population, mating_threshold, transmission_probability

  infect_list = {} of Int32 => Bool

  population.each do |id, person|

    next if person.infected == false

    population.each do |id, n_person|
      
      next if person.id == n_person.id

      if person.promiscuity + n_person.promiscuity > mating_threshold

        if rand > transmission_probability
            
          if person.infected || n_person.infected

              infect_list[person.id] = true
              infect_list[n_person.id] = true
          end
        end
      end
    end
  end
  update_infected infect_list, population
end



def update_infected infect_list, population

  infect_list.each do |person_id, infected_status|

    population[person_id].infected = infected_status
  end
end

def current_infected_count population

  sick_count = 0

  population.each do |id, p|

    if p.infected
      sick_count+=1
    end
  end

  return sick_count
end

def current_uninfected_count population

  healthy = population.length - (current_infected_count population)
  return healthy
end


# set up the simulation
simulation_runs = 1 #how many times the simulation runs
save_previous_state = false #the infected from the previous generation informs the current generation.


p = create_population 10, 5, 4

puts "Total population = #{p.length}"
puts "Current infected = #{current_infected_count p}"

simulation_runs.times do |s|
  simulate_interaction p, 0.5, 0.8
end

puts "After #{simulation_runs} days, current infected = #{current_infected_count p}"

puts "/////////////END////////////////"