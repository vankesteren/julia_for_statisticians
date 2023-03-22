using Serialization
using DataFrames
using CategoricalArrays
using GLM
using MixedModels
using StatsPlots

# load data from disk
df = deserialize("dataset.dat")

# use only first 1000
df_s = df[1:1000, :]


# note that missing values are ignored by default
frm_linear = @formula(x5 ~ x1 + x2 + x3 + fruit)
fit_linear = lm(frm_linear, df_s);
fit_linear
serialize("fit_linear.dat", fit_linear)

# add x4 predictor
frm_linear_2 = @formula(x5 ~ x1 + x2 + x3 + x4 + fruit)
fit_linear_2 = lm(frm_linear_2, df_s)

# add subj id as predicto
frm_linear_3 = @formula(x5 ~ x1 + x2 + x3 + x4 + fruit + id)
fit_linear_3 = lm(frm_linear_3, df_s)

# we can do all kinds of things we're used to in R
# perform f-test / ANOVA
ftest(fit_linear.model, fit_linear_2.model, fit_linear_3.model)
predict(fit_linear)
loglikelihood(fit_linear)
deviance(fit_linear)
density(residuals(fit_linear))

# we can also do logistic regression
fit_logistic = glm(@formula(x5 > 0 ~ x1 + x2 + x3 + x4), df_s, Binomial())

# and multilevel regression like in LME4
frm_mixed = @formula(x5 ~ x1 + x2 + x3 + x4 + fruit + (1 | id))
fit_mixed = fit(MixedModel, frm_mixed, df_s)
aic(fit_mixed)
density(residuals(fit_mixed))
plot(vec(ranef(fit_mixed)[1]); xlabel = "group", ylabel = "estimated intercept")

# Compare mixed to fixed
y = dropmissing(df_s)[!,:x5]
y_hat_fixed = predict(fit_linear_3)
y_hat_mixed = predict(fit_mixed)

# compare linear and mixed model predictions
scatter(y, y_hat_linear;
    label = "linear",
    xlabel = "observed",
    ylabel = "predicted"
)
scatter!(y, y_hat_mixed; label = "mixed")

# use full data for mixedmodel with REML fitting
fit_mixed_large = fit(MixedModel, frm_mixed, df; REML = true)
