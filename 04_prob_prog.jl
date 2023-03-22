using Distributions, Random, Turing
using LinearAlgebra
using StatsPlots
using Serialization

# get data as model matrices
fit_linear = deserialize("fit_linear.dat")
X = modelmatrix(fit_linear)
y = response(fit_linear)

# create probabilistic program using @model macro and distributions.jl functions
@model function bayesian_regression(y::Vector, X::Matrix)
    N, P = size(X)

    # priors
    σ² ~ truncated(Normal(0, 10); lower=0)
    β ~ MvNormal(zeros(P), sqrt(10))
    μ = X*β

    # likelihood
    y ~ MvNormal(μ, σ²)
end

# instantiate and sample from the model
model = bayesian_regression(y, X)
chain = sample(model, NUTS(), 10_000)

# plot!
plot(chain)
