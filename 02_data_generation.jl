# Distributions and data generation using Julia
using Random
using Statistics
using Distributions
using DataFrames
using LinearAlgebra
using StatsPlots
using CategoricalArrays
using Serialization
using CSV

# DISTRIBUTIONS
# Distributions are objects!
t_dist = TDist(1.5)

# they have sensible methods for moments and properties
mean(t_dist)
var(t_dist)
skewness(t_dist)
mode(t_dist)
quantile(t_dist, 0.95)

# evaluating probability density
pdf(t_dist, 0.0)
logpdf(t_dist, 2.1)

# if you want to assess a vector, use broadcasting!
logpdf.(t_dist, [1.0, -2.1, 0.4])

# we can also do truncation
t_trunc = truncated(t_dist, -3, 3)
pdf.(t_trunc, [-3.1, -2.8, 0.0])

# discrete distributions are supported too!
pois = Poisson(2.9)
mode(pois)
pdf.(pois, [0.2, 2.1, 2])

# StatsPlots also supports plotting the distributions
plot(t_dist, -5, 5)
plot(t_trunc, -5, 5)
plot(pois)

# distribution fitting
x_obs = [-2.1, 5.9, 1.1, 1.2, 0.4, -3.2]
cauchy_fitted = fit(Cauchy, x_obs)
normal_fitted = fit(Normal, x_obs)

# which one fits better to this sample?
sum(logpdf.(cauchy_fitted, x_obs))
sum(logpdf.(normal_fitted, x_obs))


# DATA GENERATION
# Generating multivariate normal data
ρ = 0.5
N = 500_000
P = 5
Σ = fill(ρ, P, P) + (1 - ρ)I
μ = range(-1, 1, P)

mv_dist = MultivariateNormal(μ, Σ)
X = rand(mv_dist, N)


# looks transposed because vectors are column vectors by default in julia

# let's convert to dataframe
df = DataFrame(transpose(X), :auto)
cov(Matrix(df))

# add a categorical feature and missing data
fruit_dist = Categorical([.4, .1, .2, .3])
fruit_lvls = ["apple", "pear", "banana", missing]
df.fruit = categorical(fruit_lvls[rand(fruit_dist, N)])

# also add an ID variable
N_per_id = 10
df.id = categorical(["Subj_$i" for i in repeat(1:Int(N/N_per_id), inner = N_per_id)])

# write to disk (like .rds or .pkl)
serialize("dataset.dat", df)

# write to disk as csv
CSV.write("dataset.csv", df)
