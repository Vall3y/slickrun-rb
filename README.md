slickrun-rb
===========

A gem for adding magic words to Bayden's SlickRun

## Install

``` bash
gem install slickrun
```

## Usage

``` ruby
require 'slickrun'
```

Upon require, the SlickRun.srl file is searched for in default locations. If you place it in a custom location, you must implicitly specify the location.

``` ruby
SlickRun.set_srl_path(MY_SRL_PATH)

SlickRun.srl_path_set?
=> true
```

Adding a magic word

``` ruby
# Add a magic word
SlickRun.add_magic_word('mymagicword', 'C:\SomeFile')

# You can also specify params, default window start mode, run as administrator, and 32bit redirection
SlickRun.add_magic_word('mymagicword', 'C:\SomeFile', '-some -params', 1, 1, 1)
```

Magic words added only apply after reseting the SlickRun application.