library(googleVis)
library(shiny)

shinyUI(fluidPage(
	titlePanel("Natural genetic variation"),
	fluidRow(
		column(5,
			sliderInput("population_size", "Number of people in the population", value=10, min=100, max=5000),
			sliderInput("number_of_loci", "Number of positions in the genome", value=1, min=1, max=20),
			radioButtons("effect_type", "Mutation effects", choices=c("Neutral", "Selection")),
			numericInput("mutation_rate_per_generation_per_locus", "Mutation rate (per genomic position per generation)", value=0.01, min=1e-5, max=1),
			sliderInput("number_of_generations", "Number of generations to simulate", value=30, max=100, min=10),
			actionButton("run_simulation", "Go forth and multiply!")
		),
		column(7,
			htmlOutput("view")
		)
	)
))
