# StatisticCalcs

[![Build Status](https://travis-ci.org/mberrueta/statistic_calcs.svg?branch=master)](https://travis-ci.org/mberrueta/statistic_calcs)
![license](https://img.shields.io/github/license/mashape/apistatus.svg)
![GitHub last commit](https://img.shields.io/github/last-commit/google/skia.svg)

## Overview

This gem allow to calculate descriptive and inference statistic in many different scenarios.
It use the Gsl library through `https://github.com/SciRuby/rb-gsl` to make the calculation faster.

### Descriptive

Summary statistics that quantitatively describe or summarize features of a collection of information.

#### Datasets Analysis

Get the `mean`, `variance`, `standard_deviation`, `max`, `min`, `skew`, `kurtosis`, `median`, `mode`, etc from a dataset.

- Simple numbers arrays
- Lower-Upper boundary arrays (rage/grouped data)

#### Distributions

Get the `mean`, `variance`, `standard_deviation`, `median`, `skewness`, `kurtosis`, `coefficient_variation`, `cumulative_less_than_x_probability`, `cumulative_greater_than_x_probability`, etc from statistics distributions.

##### Discrete

Properties of observable (either finite or countably infinite) pre-defined values.

- beta
- chi_square
- exponential
- fisher_snedecor
- gamma
- gumbel_maximum
- gumbel_minimum
- log_normal
- normal
- pareto
- t_student
- weibull

##### Continuos

Properties of infinite number of outcomes.

- binomial
- geometric
- hypergeometric
- hyperpascal
- pascal
- poisson

### Inference

Process of deducing properties of an underlying probability distribution by analysis of data.
Inferential statistical analysis infers properties about a unknowns population.

- Mean Known Sigma `P(A < mu < B) = 1 - alpha`
- Mean Unknown Sigma `P(A < mu < B) = 1 - alpha`
- Variance `P(A < sigma^2 < B) = 1 - alpha`
- Standard deviation `P(A < sigma < B) = 1 - alpha`
- P Bernulli process `P(A < p < B) = 1 - alpha`

#### Testing hypotheses

Test `Type 1`, `Type 2` or `Type 3` hypotheses over

- Mean Known Sigma
- Mean Unknown Sigma
- Variance
- Standard deviation
- P Bernulli process

#### Comparing population parameters

Compare 2 parameters to determine if one os greater than other

- Mean Known Sigma
- Mean Unknown Sigma
- Mean Independent population
- Variance
- Standard deviation

#### Data set tests

- Independence
- Chi-square contrast
- Goodness of fit

#### Regression and correlation analysis

- Simple linear
- Multiple linear

## Installation

**Note that the GSL libraries must already be installed before Ruby/GSL can be installed:**

- Debian/Ubuntu: `sudo apt-get install libgsl0ldbl libgsl0-dev`
- Fedora/SuSE: +gsl-devel+
- Gentoo: +sci-libs/gsl+
- OS X: `brew install gsl`

Add this line to your application's Gemfile:

```ruby
gem 'statistic_calcs'
```

And then execute:

    `$ bundle`

Or install it yourself as:

    `$ gem install statistic_calcs`

## Usage

### For a continue / discrete distribution

```ruby
  # calc to get f(x) & g(x), knowing x
  options = { mean: 0, standard_deviation: 1, x: 1.64489 }
  dist = StatisticCalcs::Descriptive::Distributions::Normal.new(options)
  dist.calc!
  dist.to_h # {:mean=>0, :standard_deviation=>1, :x=>1.64489, :cumulative_less_than_x_probability=>0.95, :cumulative_greater_than_x_probability=>0.05, :variance=>1}

  # calc to get f(x) & g(x), knowing f_x
  options = { mean: 0, standard_deviation: 1, f_x: 0.92507 }

  # calc to get f(x) & g(x), knowing g_x
  options = { mean: 0, standard_deviation: 1, g_x: 0.07493 }
```

#### Also some of the distribution has aliases for their values to make it easier to use

Example:

``` ruby
  ChiSquare
    attr_accessor :degrees_of_freedom
    attr_alias :v, :degrees_of_freedom
    attr_alias :nu, :degrees_of_freedom
```

### For datasets

```ruby

  # Simple number array

  array = [-5, 1.2, 2.3, 3.4]
  calc = StatisticCalcs::DataSet.new(x_values: array)
  calc.analyze! # @kurtosis=-1.76886, @max=3.4, @mean=0.475, @median=1.75, @min=-5.0, @skew=-0.62433, @standard_deviation=3.758878378807522, @variance=14.12917

  # with lower-upper boundary values
  x_values = [1.2, 2.3, 3.4, 1]
  lower_class_boundary_values = [1.2, 4.3, 9.4, 14.5]
  upper_class_boundary_values = [4.3, 9.4, 14.5, 19.6]

  calc = StatisticCalcs::GroupedDataSet.new(
          x_values: x_values,
          lower_class_boundary_values: lower_class_boundary_values,
          upper_class_boundary_values: upper_class_boundary_values
         )
  calc.analyze!
```

### Mean inference

#### Known population standard deviation

To calculate the population lower and upper limits, knowing sigma.

```ruby
  options = { alpha: 0.1, standard_deviation: 15.0, sample_size: 10, sample_mean: 246.0 }
  calculator = StatisticCalcs::Inference::KnownSigmaMean.new(options)
  calculator.calc!
  # @deviation_amount=1.64485 (z-normal), @population_mean_lower_limit=238.19779138600805, @population_mean_upper_limit=253.80220861399195, @population_standard_deviation=15.0, @sample_error=8
```

To calculate the sample size.

```ruby
  options = { alpha: 0.1, standard_deviation: 15.0, sample_mean: 246.0, sample_error: 5 }
  calculator = StatisticCalcs::Inference::KnownSigmaMean.new(options)
  calculator.calc!
  # @sample_size=25
```

#### Important. If you know the total population size, adding will correct the values

`population_size: 900`

#### Unknown population standard deviation

To calculate the population lower and upper limits, if you doesn't know sigma you should use the sample standard deviation:

```ruby
  options = { alpha: 0.05, sample_standard_deviation: 1.7935, sample_size: 4, sample_mean: 17.35 }
  calculator = StatisticCalcs::Inference::UnknownSigmaMean.new(options)
  calculator.calc!
  calculator.to_h # @deviation_amount=3.18245 (t student), @population_mean_lower_limit=14.4961..., @population_mean_upper_limit=20.2038..., @sample_error=3
```

### Variance inference

Will use the sample variance to estimate the population variance with a error:
So the pop variance will be X +/- error -> will be between lower_limit < x < upper_limit

```ruby
  options = { alpha: 0.1, sample_variance: 14_400, sample_size: 15 }
  calculator = StatisticCalcs::Inference::Variance.new(options)
  calculator.calc!
  calculator.to_h
  # { :degrees_of_freedom=>14, :population_variance_lower_limit=>8511.791744828643,  :population_variance_upper_limit=>30681.989398276877,  :sample_error=>11085.098826724117, :limits_relationship_variance=>3.6046452166687213}
```

To estimate how to improve an error, and get how much samples you will need, it use the relationship between lower and upper,
so the R = B /A -> improving the R will improve the error

```ruby
  options = { alpha: 0.1, sample_variance: 14_400, limits_relationship_variance: 4 }
  calculator = StatisticCalcs::Inference::Variance.new(options)
  calculator.calc!
  calculator.to_h
  # { :sample_size=>14, :degrees_of_freedom=>13 }
```

### Standard deviation inference

Same as variance, can be used to estimate the standard deviation of the total population

```ruby
  options = { alpha: 0.1, sample_standard_deviation: 120, sample_size: 15 }
  calculator = StatisticCalcs::Inference::StandardDeviation.new(options)
  calculator.calc!
  calculator.to_h
  # { degrees_of_freedom=>14, :limits_relationship_standard_deviation=>1.8985903235476371, :population_standard_deviation_lower_limit=>92.25937212461747, :population_standard_deviation_upper_limit=>175.16275117237933,  :sample_error=>41.45168952388093 }
```

Same as variance, to improve the error

```ruby
  options = { alpha: 0.1, sample_standard_deviation: 14_400, limits_relationship_variance: 4 }
  calculator = StatisticCalcs::Inference::StandardDeviation.new(options)
  calculator.calc!
  calculator.to_h
  # { :sample_size=>14, :degrees_of_freedom=>13 }
```

### P of Bernoulli process inference

In a Bernoulli process, if the sampling is made to the Binomial
the size of the sample `n` is fixed and the number of successes obtained `r` is observed in the sample.

Therefore, the estimator `p` is a random variable of Binomial behavior
corresponding to the probability of success of the Process a Bernoulli Process.
Sample p'= r /n and population is P(A < p < B) = 1 - alpha.

```ruby
  options = { alpha: 0.1, n: 30, r: 3 }
  calculator = StatisticCalcs::Inference::PBernoulliProcess.new(options)
  calculator.calc!
  calculator.to_h
  # { :confidence_level=>0.9, :sample_probability_of_success=>0.1, :probability_of_success_lower_limit=>0.02782, :probability_of_success_upper_limit=>0.2386, :sample_error=>0.10539 }
```

### Testing hypotheses

TODO: to be impleted - priority 3

### Comparing population parameters

TODO: to be impleted - priority 4

### Data set tests

TODO: to be impleted - priority 2

### Regression and correlation analysis

#### Simple linear regression

Estimation of a variable (the dependent variable) from another's variables (the independent variables).
This class will calculate the related correlation or degree of relationship between the variables,
in which will try to determine how well a linear equation, describes or explains the relationship between them
Model: `Y = Beta0 + Beta1 X + E`
Estimator: `y = b0 + b1 x`
Y: variable to explain
X: explains variable, known value (constant)
Beta0: intercept
Beta1: slope
E: disturbance of the environment, error, noise

```ruby
  options = { x_values: x_values, y_values: y_values }
  x_values = [3.0402, 2.9819, 3.0934, 3.805, 5.423]
  y_values = [8.014, 7.891, 8.207, 8.31, 8.45]

  calculator = StatisticCalcs::Regression::SimpleLinearRegression.new(options)
  calculator.calc!
  calculator.to_h
  # {
  #   b1: 0.18134495612017704, # slope
  #   b0: 7.509099759481907, # intercept
  #   n: 5,
  #   degrees_of_freedom: 3,
  #   r: 0.8372299658466078, # correlation_coefficient_estimator
  #   r_square: 0.7009540157115121, # determination_coefficient_estimator
  #   r_square_adj: 0.7009540157115121, determination_coefficient_adjusted_estimator
  #   covariance: 0.15573262000000554
  #   x_values_variance: 1.07346
  #   x_values_standard_deviation: 1.0360770675968076
  #   equation: y = 7.509 + 0.181 x

  #   ro_boundaries= 'P(-0.172 < ro < 0.989) = 95.0%'
  #   ro_lower_limit= -0.17232618950437983
  #   ro_upper_limit= 0.9889779447869926

  #   ro_square_boundaries= 'P(0.03 < ro < 0.978) = 95.0%'
  #   ro_square_lower_limit= 0.02969631558909943
  #   ro_square_upper_limit= 0.9780773752751039

  #   valid_correlation_for_social_problems: true # > 0.6
  #   valid_correlation_for_economic_problems: true # > 0.7
  #   valid_correlation_for_tech_problems: false # > 0.8
  #   b1_standard_deviation = 0.06838629521911997
  #   model_standard_deviation = 0.14170694442887077
  #   model_variance = 0.02008085809936707
  # }

  # And get a value
  result = subject.y0_estimation(5.401)
  result[:y0] # 8.488543867486984
  result[:lower_limit] # 8.060977652566306
  result[:upper_limit] # 8.916110082407661
  result[:y0_boundaries] # 'P(8.061 < y0 < 8.916) = 95.0%'
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at `https://github.com/mberrueta/statistic_calcs`. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the StatisticCalcs project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/mberrueta/statistic_calcs/blob/master/CODE_OF_CONDUCT.md).
