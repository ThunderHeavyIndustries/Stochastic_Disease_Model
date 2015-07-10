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

#TODO currently this doesn't evenly distribute the parameters
def create_population population_size, starting_infected, gender_ratio, hetero_homo_ratio

  # Gender set based on gender ratio, pass 4 then every 4th will be male

  population = {} of Int32 => Agent #this is our hash of agents from the agent class identified by their id

  (0...population_size).each do |n|

    if n % gender_ratio == 0
      gender = "male"
    else
      gender = "female"
    end

    if n % hetero_homo_ratio == 0
      sexuality = "homo"
    else
      sexuality = "hetero"
    end

    if starting_infected>0

      agent = Agent.new n , rand, gender, true, sexuality, 0
      population[agent.id] = agent
      starting_infected = starting_infected-1

    else

     agent = Agent.new n , rand, gender, false, sexuality, 0
     population[agent.id] = agent
    end
  end
  return population
end

def simulate_interaction population, mating_threshold, transmission_probability, mating_behavior

  infect_list = {} of Int32 => Bool

  population.each do |id, person|

    next if person.infected == false

    population.each do |id, n_person|
      
      next if check_compatability person, n_person, mating_behavior == false

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

def check_compatability person, n_person, mating_behavior
  #lets play with the myraid permutations of human sexual interactions:
      if person.id == n_person.id 
        compatible = false # Self love is harmless
      elsif mating_behavior == "hetero" && person.gender == n_person.gender 
        compatible = false
      elsif mating_behavior == "hetero" && person.sexuality || n_person.sexuality != "hetero"
        compatible = false
      elsif mating_behavior == "homo" && person.gender != n_person.gender
        compatible = false
      elsif mating_behavior == "homo" && person.sexuality || n_person.sexuality != "homo"
        compatible = false
      end

  return compatible
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


# Set up the simulation
simulation_runs = 10 #how many times the simulation runs
save_previous_state = false #the infected from the previous generation informs the current generation.
elapsed_periods = 0
p = create_population 10000, 5, 2, 3 

puts "Total population = #{p.length}"
puts "Current infected = #{current_infected_count p}"

#run the simulation
simulation_runs.times do |s|
  simulate_interaction p, 0.5, 0.9, "hetero"
  puts "Day #{s}, and current infected = #{current_infected_count p}"
  elapsed_periods += 1
  break if p.length == current_infected_count p
end

puts "After #{elapsed_periods} days, current infected = #{current_infected_count p}"
puts "/////////////END////////////////"