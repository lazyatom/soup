#!/usr/bin/env ruby

# We need to do a bit of extra work here, because Snip will undefine a 
# whole bunch of stuff that spec adds, like the Object#should method.
$LOAD_PATH.unshift File.join(File.dirname(__FILE__), *%w[.. lib])
require 'soup'

# This is basically the contents of rspec's own spec runner. It's just
# that we needed to require 'soup' before it.
require 'rubygems'
require 'spec'
exit ::Spec::Runner::CommandLine.run(rspec_options)