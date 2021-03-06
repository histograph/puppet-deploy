#!/usr/bin/env bash
# run as root
echo
echo "  ---%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%---"
echo "  ---%%%%% INSTALLING DIFF TOOL %%%%%---"
echo "  ---%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%---"
echo

#set -x
source $(dirname $0)/../utils/set-vars "${1}"

RUBY_PATH=/opt/puppetlabs/puppet/bin

sudo ${RUBY_PATH}/gem install hashed-diff

cat > ${DIFF_TOOL_PATH} << DIFF_SCRIPT
#! ${RUBY_PATH}/ruby
#
# This file was generated by RubyGems.
#
# The application 'hashed-diff' is installed as part of a gem, and
# this file is here to facilitate running it.
#

require 'rubygems'

version = ">= 0"

if ARGV.first
  str = ARGV.first
  str = str.dup.force_encoding("BINARY") if str.respond_to? :force_encoding
  if str =~ /\A_(.*)_\z/
    version = $1
    ARGV.shift
  end
end

gem 'hashed-diff', version
load Gem.bin_path('hashed-diff', 'hashed-diff', version)
DIFF_SCRIPT

sudo chmod 755 ${DIFF_TOOL_PATH}
