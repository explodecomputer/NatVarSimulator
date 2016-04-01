library(googleVis)
library(shiny)

shinyUI(fluidPage(
	titlePanel("Natural genetic variation"),
	fluidRow(
		column(5,
			sliderInput("population_size", "Number of people in the population", value=10, min=100, max=5000),
			sliderInput("number_of_loci", "Number of base pairs in the genome", value=1, min=1, max=20),
			radioButtons("effect_type", "Mutation effects", choices=c("Neutral", "Selection")),
			numericInput("mutation_rate_per_generation_per_locus", "Mutation rate (per genomic position per generation)", value=0.01, min=1e-5, max=1),
			sliderInput("number_of_generations", "Number of generations to simulate", value=30, max=100, min=10),
			actionButton("run_simulation", "Run the simulations")
		),
		column(7,
			htmlOutput("view")
		)
	),
	hr(),
	fluidRow(
		column(6,
			h3("Background"),
			wellPanel(
				p("
					The human genome is about 3 billion base pairs in length. Any two individuals in the population are almost genetically identical, but on average their genome sequences will differ every once every 1000 base pairs. To complicate matters, if you take any there individuals randomly from the population there will be some positions where individual 1 and 2 are identical whereas 3 is different, or where 1 and 3 are identical but 2 is different etc. That is to say that some mutations are ", strong("common"), " in the population, with the mutant allele being shared by some members while not being present in others.
				"),
				p("How does this ", strong("natural genetic variation"), " arise?"),
				p("Every generation each new child is born with new mutations. Over time, the fate of those mutations is dependent on stochastic events, the size of the population, and how it effects the fitness of the individual (and a few other complicating factors).")
			)
		),
		column(6,
			h3("How the simulations work"),
			wellPanel(
				p("These simulations do the following:"),

				tags$ol(
					tags$li("Creates a population of diploid people, half males and half females, each with some (small, for computational reasons!) number of base pairs in the genome"),
					tags$li("For each base pair randomly decides how beneficial, detrimental, or non-consequential (neutral) a mutation at that position would be to an individual's fitness (also known as a selection coefficient)"),
					tags$li("Randomly Generates mutations in each individual depending on the mutation rate"),
					tags$li("Males and females reproduce, with individuals with the highest number of beneficial mutations more likely to have more children. To create a new child the simulation chooses a random allele from the male and the female genomes from each position, generating a new diploid genome."),
					tags$li("The resulting children become the next generation, and the cycle from 3 to 4 continues for some number of generations")
				),

				p("The graph shows the changing frequency of the mutant allele for each genomic position from generation to generation. Notice that all new mutations start with a very low frequency - that's because only one person has that mutation, it has only just been introduced into the population. But after a few generations that mutation could have disappeared (frequency of 0 again) or if it is continuously ")
			)
		)
	)
))
