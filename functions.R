library(ggplot2)
library(reshape2)
library(lubridate)

make_population <- function(male_population_size, female_population_size, number_of_loci)
{
	males1 <- matrix(FALSE, male_population_size, number_of_loci)
	males2 <- matrix(FALSE, male_population_size, number_of_loci)
	females1 <- matrix(FALSE, female_population_size, number_of_loci)
	females2 <- matrix(FALSE, female_population_size, number_of_loci)
	return(list(males1=males1, males2=males2, females1=females1, females2=females2))
}


make_mutations <- function(population, mutation_rate_per_generation_per_locus)
{
	nloci <- ncol(population$males1)

	population <- lapply(population, function(x)
	{
		m <- min(1, mutation_rate_per_generation_per_locus / 2)
		mutation_index <- as.logical(rbinom(length(x), 1, m))
		if(any(mutation_index))
		{
			x[mutation_index] <- ! x[mutation_index]
		}
		return(x)
	})
	return(population)
}


scale_val <- function(x)
{
	x <- x - min(x) + 0.01
	x <- x / (max(x) + 0.01)
	return(x)
}


calc_fitness <- function(pop1, pop2, fitness_effects)
{
	f <- pop1 %*% fitness_effects + pop2 %*% fitness_effects
	return(scale_val(as.numeric(f)))
}


reproduce <- function(population, population_size, fitness_effects, mutation_rate_per_generation_per_locus)
{
	male_fitness <- calc_fitness(population$males1, population$males2, fitness_effects)
	female_fitness <- calc_fitness(population$females1, population$females2, fitness_effects)
	male_partner <- sample(1:nrow(population$males1), population_size/2, replace=TRUE, prob = male_fitness)
	female_partner <- sample(1:nrow(population$females1), population_size/2, replace=TRUE, prob = female_fitness)

	x <- population$males1[male_partner, , drop=FALSE]
	locus <- sample(1:ncol(x), ncol(x)/2, replace=FALSE)
	x[, locus] <- population$males2[male_partner, locus, drop=FALSE]
	child_paternal <- x

	x <- population$females1[female_partner, , drop=FALSE]
	locus <- sample(1:ncol(x), ncol(x)/2, replace=FALSE)
	x[, locus] <- population$females2[female_partner, locus, drop=FALSE]
	child_maternal <- x

	# sex <- sample(1:2, nrow(child_paternal), replace=TRUE)

	population$males1 <- child_paternal[1:(nrow(child_paternal)/2), , drop=FALSE]
	population$males2 <- child_maternal[1:(nrow(child_paternal)/2), , drop=FALSE]
	population$females1 <- child_paternal[1:(nrow(child_paternal)/2) + (nrow(child_paternal)/2), , drop=FALSE]
	population$females2 <- child_maternal[1:(nrow(child_paternal)/2) + (nrow(child_paternal)/2), , drop=FALSE]

	population <- make_mutations(population, mutation_rate_per_generation_per_locus)

	return(population)
}


get_freqs <- function(generations, fitness_effects)
{
	require(reshape2)
	require(lubridate)
	a <- matrix(sapply(generations, function(x)
	{
		
		a <- matrix(sapply(x, function(y)
		{
			colMeans(y)
		}), ncol=4)
		rowMeans(a)
	}), ncol=length(generations))
	a <- melt(a, c("mutation", "generation"), value.name="freq")
	b <- data.frame(mutation=1:length(fitness_effects), fitness_effects=fitness_effects)
	a <- merge(a, b, by="mutation")
	a <- a[order(a$generation, a$mutation), ]
	# a$date <- Sys.Date()
	# a$date <- a$date + years(25 * (a$generation-1))
	a$year <- 2016 + (a$generation - 1) * 25
	return(a)
}


run_generations <- function(generations, population_size, fitness_effects, number_of_generations, mutation_rate_per_generation_per_locus)
{
	l <- length(generations)
	for(i in 1:number_of_generations)
	{
		generations[[i + l]] <- reproduce(generations[[l + i - 1]], population_size, fitness_effects, mutation_rate_per_generation_per_locus)
	}
	return(generations)
}



plot_people <- function(population)
{
	dat1 <- data.frame(val=rowSums(population$males1) + rowSums(population$males2), sex="Male")
	dat1 <- dat1[order(dat1$val, decreasing=TRUE), ]
	dat1$id <- 1:nrow(dat1)
	d <- ceiling(sqrt(nrow(dat1)))
	dat1$x <- ceiling(dat1$id / d)
	dat1$y <- (dat1$id-1) %% d

	dat2 <- data.frame(val=rowSums(population$females1) + rowSums(population$females2), sex="Female")
	dat2 <- dat2[order(dat2$val, decreasing=TRUE), ]
	dat2$id <- 1:nrow(dat2)
	d <- ceiling(sqrt(nrow(dat2)))
	dat2$x <- ceiling(dat2$id / d)
	dat2$y <- (dat2$id-1) %% d

	dat <- rbind(dat1, dat2)

	p <- ggplot(dat, aes(x=x, y=y)) +
	geom_point(aes(colour=val), size=5) +
	scale_colour_gradient(low="red", high="blue") +
	facet_grid(. ~ sex) +
	theme(axis.text=element_blank(), axis.ticks=element_blank(), axis.title=element_blank(), legend.position="none")
	return(p)
}


plot_frequencies <- function(f)
{
	p <- ggplot(f, aes(x=generation, y=freq)) +
		geom_line(aes(group=mutation, col=fitness_effects)) +
		ylim(c(0,1)) +
		scale_colour_gradientn(colours=c("blue", "black", "red"))	
	return(p)
}

