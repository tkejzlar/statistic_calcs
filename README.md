# StatisticCalcs

## Overview

This gem allow to calculate descriptive and inference statistic in many different scenarios.
It use the Gsl library through `https://github.com/SciRuby/rb-gsl` to make the calculation faster.

### Discrete Distributions

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

### Continuos Distributions

- binomial
- geometric
- hypergeometric
- hyperpascal
- pascal
- poisson

### Datasets

- simple numbers arrays
- lower-upper boundary arrays

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'statistic_calcs'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install statistic_calcs

## Usage

### For a continue / discrete distribution

```ruby
  # calc to get f(x) & g(x), knowing x
  options = { mean: 0, standard_deviation: 1, x: 1.64489 }
  dist = StatisticCalcs::Descriptive::Distributions::Normal.new(options)
  dist.calc!
  subject.to_h # {:mean=>0, :standard_deviation=>1, :x=>1.64489, :cumulative_less_than_x_probability=>0.95, :cumulative_greater_than_x_probability=>0.05, :variance=>1}

  # calc to get f(x) & g(x), knowing f_x
  options = { mean: 0, standard_deviation: 1, f_x: 0.92507 }

  # calc to get f(x) & g(x), knowing g_x
  options = { mean: 0, standard_deviation: 1, g_x: 0.07493 }
```

_Also some of the distibution has aliases for their values to make it easier to use_

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

  # with lower-upper boindary values

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

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mberrueta/statistic_calcs. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the StatisticCalcs project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/mberrueta/statistic_calcs/blob/master/CODE_OF_CONDUCT.md).
