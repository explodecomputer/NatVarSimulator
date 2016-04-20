library(googleVis)
library(shiny)
source("functions.R")

shinyServer(function(input, output) {


	observeEvent(input$run_simulation, 
	{


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
		print(head(f))

		gvissettings <- '
		{"iconType":"LINE","showTrails":false}
		'

		output$view <- renderGvis({

			gvisMotionChart(
				f, 
				idvar ='mutation', 
				xvar = 'fitness_effects',
				yvar = 'allele_frequency', 
				timevar= 'year',
				options=list(state=gvissettings)
			)
		})
	})

})




