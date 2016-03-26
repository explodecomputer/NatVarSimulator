library(ggplot2)
library(lubridate)

male_population_size <- 50
female_population_size <- 50
population_size <- male_population_size + female_population_size
number_of_loci <- 20
fitness_effects <- seq(1,-1,length.out=number_of_loci)
# fitness_effects <- 0.5
mutation_rate_per_generation_per_locus <- 0.01
number_of_generations <- 100


generations <- list()
generations[[1]] <- make_population(male_population_size, female_population_size, number_of_loci)
generations[[1]] <- make_mutations(generations[[1]], mutation_rate_per_generation_per_locus)
generations <- run_generations(generations, population_size, fitness_effects, number_of_generations, mutation_rate_per_generation_per_locus)
f <- get_freqs(generations, fitness_effects)

ggplot(subset(f), aes(x=generation, y=freq)) +
geom_line(aes(group=mutation, col=fitness_effects)) +
ylim(c(0,1)) +
scale_colour_gradientn(colours=c("blue", "black", "red"))	

for(i in 1:100)
{
	print(plot_people(generations[[i]]))
}


input <- list()
input$population_size <- 100
input$number_of_loci <- 20
input$mutation_rate_per_generation_per_locus <- 0.01
fitness_effects <- seq(1,-1,length.out=input$number_of_loci)
input$number_of_generations <- 100


generations <- list()
generations[[1]] <- make_population(
	input$population_size/2, 
	input$population_size/2, 
	input$number_of_loci
)

generations[[1]] <- make_mutations(
	generations[[1]], 
	input$mutation_rate_per_generation_per_locus
)

if(input$effect_type == "Neutral")
{
	fitness_effects <- rep(0, input$number_of_loci)
} else {
	fitness_effects <- seq(1,-1,length.out=input$number_of_loci)
}

generations <- run_generations(
	generations, 
	input$population_size, 
	fitness_effects, 
	input$number_of_generations - 1,
	input$mutation_rate_per_generation_per_locus
)


f <- get_freqs(generations, fitness_effects)
plot_frequencies(f)

