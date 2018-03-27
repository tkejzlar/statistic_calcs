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
- P Bernoulli process `P(A < p < B) = 1 - alpha`

#### Testing hypotheses

Test `Type 1`, `Type 2` or `Type 3` hypotheses over

- Mean Known Sigma
- Mean Unknown Sigma
- Variance
- Standard deviation
- P Bernoulli process

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

- Debian/Ubuntu: `sudo apt-get install libgsl2 libgsl0-dev`
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
  dist = StatisticCalcs::Distributions::Normal.new(options)
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
  calc = StatisticCalcs::DataSets::DataSet.new(x_values: array)
  calc.calc! # @kurtosis=-1.76886, @max=3.4, @mean=0.475, @median=1.75, @min=-5.0, @skew=-0.62433, @standard_deviation=3.758878378807522, @variance=14.12917

  # with lower-upper boundary values
  x_values = [1.2, 2.3, 3.4, 1]
  lower_class_boundary_values = [1.2, 4.3, 9.4, 14.5]
  upper_class_boundary_values = [4.3, 9.4, 14.5, 19.6]

  calc = StatisticCalcs::GroupedDataSet.new(
          x_values: x_values,
          lower_class_boundary_values: lower_class_boundary_values,
          upper_class_boundary_values: upper_class_boundary_values
         )
  calc.calc!
```

Also to generate the histogram

```ruby
  list = [738, 600, 920, 1000, 897, 999, 601, 602]
  calc = StatisticCalcs::DataSets::DataSet.new(x_values: list)
  calc.split_in(4) # or group_each(100)
  calc.intervals # => 4
  calc.range # => 100
  calc.histogram_keys # => ['less_than_700.0', '700.0..800.0', '800.0..900.0', '900.0_or_more_than']
  calc.adjusted_keys # => ['600..700.0', '700.0..800.0', '800.0..900.0', '900.0..1000']
  calc.histogram_values # => [3, 1, 1, 3]
  calc.grouped_values # => [[600, 601, 602], [738], [897], [920, 1000, 999]]
  calc.grouped_values_hash # => {'less_than_700.0'=>[600, 601, 602], '700.0..800.0'=>[738], '800.0..900.0'=>[897], '900.0_or_more_than'=>[920, 1000, 999]}
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

Define and test an Hypotheses on statistic variables.
Define the null hypotheses as unquestionable, you try to prove that it is false.

```md
h0               = null hypothesis
h1               = alternative hypothesis
confidence_level = Prob(no reject true h0). Correct decision
alpha            = Prob(reject true h0). Type 1 error. worst error
test_power       = Prob(reject false h0). Type 2 less serious error
beta             = Prob(no reject false h0). Correct decision
```

Use the different cases depending the problem

```md
CASE_1 = unilateral right
CASE_2 = unilateral left
CASE_3 = bilateral
```

#### Mean

Test a sample mean, knowing or not the population standard deviation

##### Known Sigma Mean

Calculated using the Normal distribution

```ruby
  options = {
    alpha: 0.05,
    standard_deviation: 15.0,
    sample_size: 10,
    sample_mean: 230.0,
    mean_to_test: 250,
    case: StatisticCalcs::HypothesisTest::Cases::CASE_1
  }
  calculator = StatisticCalcs::HypothesisTest::KnownSigmaMean.new(options)
  calculator.calc!
  calculator.to_h
  # {
  #   null_hypothesis: "mean <= x0 (250)",
  #   alternative_hypothesis: "mean > x1 ()",
  #   critical_fractil: 257.8022086139919,
  #   reject: false,
  #   reject_condition: "X > Xc -> reject H0. `230.0 > 257.8` -> false"
  # }
```

##### Unknown Sigma Mean

Calculated using the TStudent distribution

```ruby
  options = {
    alpha: 0.05,
    standard_deviation: 15.0,
    sample_size: 10,
    sample_mean: 230.0,
    mean_to_test: 250,
    case: StatisticCalcs::HypothesisTest::Cases::CASE_1
  }
  calculator = StatisticCalcs::HypothesisTest::KnownSigmaMean.new(options)
  calculator.calc!
  calculator.to_h
  # {
  # null_hypothesis: "mean <= x0 (250)",
  # alternative_hypothesis: "mean > x1 ()",
  # critical_fractil: 258.69520420244686,
  # reject: false,
  # reject_condition: "X > Xc -> reject H0. `230.0 > 258.7` -> false"
  # }
```

##### Variance

```ruby
  options = {
    sample_size: 30,
    alpha: 0.05,
    sample_variance: 225,
    variance_to_test: 400,
    case: StatisticCalcs::HypothesisTest::Cases::CASE_1
  }
  calculator = StatisticCalcs::HypothesisTest::Variance.new(options)
  calculator.calc!
  calculator.to_h
  # {
  #   null_hypothesis: 'sigma^2 <= s0 (400)',
  #   alternative_hypothesis: 'sigma^2 > s1 ()',
  #   critical_fractil: 586.9926896551724,
  #   reject: false,
  #   reject_condition: 'S^2 > S^2c -> reject H0. `225 > 586.99` -> false',
  # }
```

##### Standard Deviation

```ruby
  options = {
    sample_size: 30,
    alpha: 0.05,
    sample_standard_deviation: 15,
    standard_deviation_to_test: 20,
    case: StatisticCalcs::HypothesisTest::Cases::CASE_1
  }
  calculator = StatisticCalcs::HypothesisTest::StandardDeviation.new(options)
  calculator.calc!
  calculator.to_h
  # {
  #   null_hypothesis: 'sigma <= s0 (20)',
  #   alternative_hypothesis: 'sigma > s1 ()',
  #   critical_fractil: 24.227932013590685,
  #   reject: false,
  #   reject_condition: 'S > Sc -> reject H0. `15 > 24.23` -> false'
  # }
```

### Comparing population parameters

TODO: to be implemented - priority 3

- variance
- standard_deviation
- mean

### Goodness and fit tests

Let's say that we have a list of data, and we want to view if those values
adjust to a statistic model. We need at least 60 values. We group in N
categories (clusters)

For instance to an uniform

- Uniform
- Normal
- Log Normal
- Gumbel Maximum
- Gumbel Minimum
- TODO: Binomial
- TODO: Poisson
- TODO: Pareto

#### If I have the list of values

```ruby
  values = [
    600, 1000, 985, 998, 692, 973, 631, 814, 739, 733, 838, 813, 731, 801, 913, 754, 778, 697, 646,
    649, 759, 909, 671, 801, 995, 677, 719, 960, 713, 881, 900, 981, 608, 909, 998, 877, 785, 681,
    897, 679, 965, 948, 684, 766, 989, 878, 807, 672, 741, 670, 752, 818, 766, 759, 866, 650, 941, 819, 756, 635
  ]
  options = { data_set: values, clusters_count: 4 }
  calculator = StatisticCalcs::ChiSquareContrast::UniformGoodnessAndFit.new(options)
  calculator.calc!
  calculator.cluster_keys # ["less_than_700.0", "700.0..800.0", "800.0..900.0", "900.0_or_more_than"])
  calculator.cluster_values # ["600..700.0", "700.0..800.0", "800.0..900.0", "900.0..1000"])
  calculator.cluster_mid_points # [650.0, 750.0, 850.0, 950.0]
  calculator.observed_frequencies # [16, 15, 13, 16]

  # model probability
  calculator.occurrence_probabilities # [0.25, 0.25, 0.25, 0.25]
  # frequency if model apply
  calculator.expected_frequencies # [15, 15, 15, 15]
  calculator.critical_chi_square # 0.4

  # So with this calculated information we can test if it match or not with the hypotheses test
  test_calc = StatisticCalcs::HypothesisTest::GoodnessAndFit.new(data: calculator)
  test_calc.calc!
  test_calc.null_hypothesis # 'Xc^2 <= X^2(1 - alpha, V). 0.4 <= 30.14353'
  test_calc.alternative_hypothesis # 'Xc^2 > X^2'
  test_calc.critical_fractil # 0.4
  test_calc.reject # true
  test_calc.reject_condition # 'Xc^2 > X^2 -> reject H0. `0.4 > 30.14` -> true'
  # model doesn't fit to uniform dist
```

#### If I have the list of occurrences

```ruby
  lower_class_boundary_values = [0, 15, 30, 45, 60, 75, 105]
  upper_class_boundary_values = [15, 30, 45, 60, 75, 105, 200]
  observed_frequencies = [8, 20, 25, 35, 25, 18, 0]
  options = {
    lower_class_boundary_values: lower_class_boundary_values,
    upper_class_boundary_values: upper_class_boundary_values,
    observed_frequencies: observed_frequencies
  }
  calculator = StatisticCalcs::ChiSquareContrast::GumbelMinimumGoodnessAndFit.new(options)
  calculator.calc!
  calculator.cluster_mid_points).to eq([7.5, 22.5, 37.5, 52.5, 67.5, 90.0, 152.5])
  calculator.occurrence_probabilities).to eq([0.6133, 0.09030, 0.0855200, 0.07447999, 0.05830, 0.062759, 0.01534])
  calculator.expected_frequencies).to eq([80.3423, 11.829300, 11.20312, 9.756879, 7.63730, 8.221559, 2.00954])
  calculator.critical_chi_square).to eq(206.1952)

  # So with this calculated information we can test if it match or not with the hypotheses test
  test_calc = StatisticCalcs::HypothesisTest::GoodnessAndFit.new(data: calculator)
  test_calc.calc!
  test_calc.null_hypothesis # 'Xc^2 <= X^2(1 - alpha, V). 206.1952 <= 9.48773'
  test_calc.alternative_hypothesis # 'Xc^2 > X^2'
  test_calc.critical_fractil # 206.1952
  test_calc.reject_condition # true
  test_calc.reject # 'Xc^2 > X^2 -> reject H0. `206.2 > 9.49` -> true'
  # model doesn't fit to uniform dist
```

#### Simple linear regression

Estimation of a variable (the dependent variable) from another variables (the independent variables).
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
  x_values = [3.0402, 2.9819, 3.0934, 3.805, 5.423]
  y_values = [8.014, 7.891, 8.207, 8.31, 8.45]
  options = { x_values: x_values, y_values: y_values }

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

#### Multiple linear regression

The most important thing that this gem make =)

Similar to simple linear regression, but can be used multiple variables to review if the independent variables affect (or not) to the dependant
Model: `Y = Beta0 + Beta1 X1 + Beta2 X2 + ... + BetaN XN +E`
Estimator: `y = b0 + b1 x1 + b2 x2 + .. + bn xn`
Y: variable to explain
X: explains variables, known values (constant) Is a `N` x `Variables count` Matrix

##### multicollinearity analysis

Usually is easy to add more variables to explain the dependent one, but if we add too much variables, and doesn´t add a significant amount,
probably is better to exclude from the list.
This analysis is too complex, and depends of many factors.
Let´s jump into code first

```ruby
  x1_values  [1, 2.5, 3.1, 4, 4.7, 5.3, 6, 7.1, 9] }
  x2_values  [9, 12, 13, 14, 14.5, 16, 17, 19, 19.6] }
  x3_values  [3, 4, 5, 2, 4, 8, 12, 10, 23.2] }
  x_values  [x1_values, x2_values, x3_values] }

  y_values  [5, 8.5, 10, 11.2, 14, 16, 16.8, 18.55, 20] }
  options  { x_values: x_values, y_values: y_values } }

  calc =  StatisticCalcs::Regression::MultipleLinearRegression.new(options)
  # all the possible combinations
  calc.possible_scenarios # [['x1'], ['x2'], ['x3'], ['x1' 'x2'], ['x1' 'x3'], ['x2' 'x3'], ['x1' 'x2' 'x3']]
  calc.possible_scenarios_keys # ['x1' 'x2' 'x3' 'x1x2' 'x1x3' 'x2x3' 'x1x2x3']

  analysis = calc.multicollinearity_analysis
  # to check which one is better you should compare the following statistics
  analysis[0] # {:name=>"x1",     delta_sum=>10.680, :prediction_sum_square=> 21.281, :r_square=>0.955, :s_square=> 1.258, :det=>1,     :p=>2, :c_p=> 5.231})
  analysis[1] # {:name=>"x2",     delta_sum=> 7.275, :prediction_sum_square=>  7.025, :r_square=>0.975, :s_square=> 0.699, :det=>1,     :p=>2, :c_p=> 0.686})
  analysis[2] # {:name=>"x3",     delta_sum=>35.603, :prediction_sum_square=>205.417, :r_square=>0.606, :s_square=>11.224, :det=>1,     :p=>2, :c_p=>86.251})
  analysis[3] # {:name=>"x1x2",   delta_sum=>11.134, :prediction_sum_square=> 27.189, :r_square=>0.976, :s_square=> 0.766, :det=>0.034, :p=>3, :c_p=> 2.341})
  analysis[5] # {:name=>"x2x3",   delta_sum=> 8.929, :prediction_sum_square=>  9.995, :r_square=>0.975, :s_square=> 0.815, :det=>0.382, :p=>3, :c_p=> 2.682})
  analysis[4] # {:name=>"x1x3",   delta_sum=>10.376, :prediction_sum_square=> 28.581, :r_square=>0.970, :s_square=> 0.988, :det=>0.261, :p=>3, :c_p=> 3.891})
  analysis[6] # {:name=>"x1x2x3", delta_sum=>14.146, :prediction_sum_square=> 45.171, :r_square=>0.978, :s_square=> 0.861, :det=>0.005, :p=>4, :c_p=> 4})

  # So first
  # 1 - Parsimony Principle: The principle that the most acceptable explanation of an occurrence, phenomenon, or event is the simplest
  # 2 - R² (which one is more related) the greatest possible. (to replace by adjusted)
  # 3 - S² (which dispersion have each one) the lowest possible
  # 4 - PRESS. Prediction square sum the lowest possible
  # 5 - DET of correlation matrix should be at least 0.1 and closed to 1 is better
  # 6 - Mallow´s cp: CP divided parameter count of each model (CP / p) should be less than 5.

  # selecting one is subjective, for the example:
  # first I remove `x3` because the r² is too slow. (the others are similar)
  # second I remove `x1` & `x1x3` because the s² is to high
  # third I remove the `x1x2` & `x1x2x3` because the PRESS is too high
  # lastly I choose `x2` only because has similar values and less variables to analyse

  # Also you can view
  calc.correlation_matrix # Matrix[[1.0, 0.9776, 0.9876, 0.778], [0.977, 1.0, 0.982, 0.859], [0.987, 0.982, 1.0, 0.785], [0.778, 0.859, 0.785, 1.0]]
  calc.r_square_matrix # Matrix[[1.0, 0.9558, 0.9754, 0.606], [0.955, 1.0, 0.965, 0.738], [0.975, 0.965, 1.0, 0.617], [0.606, 0.738, 0.617, 1.0]]
  calc.adj_r_square_matrix # Matrix[[1.0, 0.9411, 0.9673, 0.475], [0.941, 1.0, 0.954, 0.651], [0.967, 0.954, 1.0, 0.489], [0.475, 0.651, 0.489, 1.0]]
```

Let's say a simple example with the following sample data 

```ruby

  x1_values  [1, 2, 3, 4, 5] }
  x2_values  [1, 3, 7, 9, 3] }
  x_values  [x1_values, x2_values] }
  y_values  [8, 9, 7, 5, 4] }
  options  { x_values: x_values, y_values: y_values } }
  calc =  StatisticCalcs::Regression::MultipleLinearRegression.new(options)
```

##### Analysis of variance (ANOVA)

```ruby
  # excel result
  # Groups  Count Sum Mean   Variance
  # Column 1  5   33  6.6    4.3
  # Column 2  5   15  3      2.5
  # Column 3      23  4.6   10.8

  calc.n # 5
  calc.x_values_mean_matrix.to_a # [3.0, 4.6]
  calc.y_values_mean # 6.6
  calc.x_values_sum_matrix.to_a # [15.0, 23.0]
  calc.y_values_sum # 33.0
  calc.x_values_variance_matrix.to_a # [2.5, 10.8]
  calc.y_values_variance # 4.3
```

##### Linear estimation

```ruby
  # excel result: liniest formula `=LINIEST(A2:A6,B2:C6,1, 1)`
  # 0.0361445783  -1.2361445783   10.1421686747 --> Slopes and intercept
  # 0.203753428    0.4234935474   1.273744148 ----> Standard errors/deviations
  # 0.8397310171   1.1740158657   #N/A -----------> R^2 coefficients, Stand error Y
  # 5.2395104895   2   #N/A  ---------------------> F observed, degrees of freedom
  # 14.443373494   2.756626506  #N/A -------------> Sum squares, Residual sum squares

  calc.b_values[:b2] #  0.03614 # slope b2
  calc.b_values[:b1] # -1.23614 # slope b1
  calc.b_values[:b0] # 10.14216 # intercept b0

  calc.b_values_standard_errors[:b2] # 0.20375
  calc.b_values_standard_errors[:b1] # 0.42349
  calc.b_values_standard_errors[:b0] # 1.27374

  calc.r_square         # 0.83973
  calc.y_standard_error # 1.17401

  calc.f_observed # 5.23951
  calc.degrees_of_freedom # 2

  calc.sum_squares          # 14.44337
  calc.residual_sum_squares #  2.75662

  calc.total_sum_squares # 17.2
  calc.r # 0.91636
```

##### Covariance, Correlation, Sum squares matrixes

```ruby
  calc.covariance_matrix.to_a # [[3.44, -2.4, -2.16], [-2.4, 2.0, 2.0], [-2.16, 2.0, 8.64]]
  calc.correlation_matrix.to_a # [[1.0, -0.91499, -0.39620], [-0.91499, 1.0, 0.48112], [-0.39620, 0.48112, 1.0]]
  calc.r_square_matrix.to_a # [[1.0, 0.83720, 0.15697], [0.83720, 1.0, 0.23148], [0.15697, 0.23148, 1.0]]
  calc.x_values_standard_deviation_matrix.to_a # [1.58113, 3.28633]
  calc.r # 0.91636
```

##### Result

```ruby
  calc.valid_correlation_for_social_problems? # true
  calc.valid_correlation_for_economic_problems? # true
  calc.valid_correlation_for_tech_problems? # true
  calc.equation # 'y = 10.142 - 1.2361 x1 + 0.0361 x2'
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at `https://github.com/mberrueta/statistic_calcs`. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the StatisticCalcs project’s codebase, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/mberrueta/statistic_calcs/blob/master/CODE_OF_CONDUCT.md).
