#!/usr/bin/env ruby

require 'net/https'
require 'openssl'
require 'openssl/x509'
require 'optparse'
require 'pathname'
require 'yaml'

require 'puppet'
require 'puppet/network/http_pool'

class Puppet::Application::UploadFacts < Puppet::Application
  run_mode :master

  option('--debug', '-d')
  option('--verbose', '-v')

  option('--logdest DEST', '-l DEST') do |arg|
    Puppet::Util::Log.newdestination(arg)
    options[:setdest] = true
  end

  option('--minutes MINUTES', '-m MINUTES') do |minutes|
    options[:time_limit] = 60 * minutes.to_i
  end

  def help
    print <<HELP
== Synopsis

Upload cached facts to the inventory service.

= Usage

  upload_facts [-d|--debug] [-v|--verbose] [-m|--minutes <minutes>]
               [-l|--logdest syslog|<file>|console]

= Description

This command will read YAML facts from the puppet master's YAML directory, and
save them to the configured facts_terminus. It is intended to be used with the
facts_terminus set to inventory_service, in order to ensure facts which have
been cached locally due to a temporary failure are still uploaded to the
inventory service.

= Usage Notes

upload_facts is intended to be run from cron, with the facts_terminus set to
inventory_service. The +--minutes+ argument should be set to the length of time
between upload_facts runs. This will ensure that only new YAML files are
uploaded.

= Options

Note that any setting that's valid in the configuration file
is also a valid long argument.  For example, 'server' is a valid configuration
parameter, so you can specify '--server <servername>' as an argument.

See the configuration file documentation at
https://docs.puppetlabs.com/puppet/latest/reference/configuration.html for
the full list of acceptable parameters. A commented list of all
configuration options can also be generated by running puppet agent with
'--genconfig'.

minutes::
  Limit the upload only to YAML files which have been added within the last n
  minutes.
HELP

    exit
  end

  def setup
    # Handle the logging settings.
    if options[:debug] or options[:verbose]
      if options[:debug]
        Puppet::Util::Log.level = :debug
      else
        Puppet::Util::Log.level = :info
      end

      Puppet::Util::Log.newdestination(:console) unless options[:setdest]
    end

    exit(Puppet.settings.print_configs ? 0 : 1) if Puppet.settings.print_configs?
  end

  def main
    dir = Pathname.new(Puppet[:yamldir]) + 'facts'

    cutoff = options[:time_limit] ? Time.now - options[:time_limit] : Time.at(0)

    files = dir.children.select do |file|
      file.extname == '.yaml' && file.mtime > cutoff
    end

    failed = false

    terminus = Puppet::Node::Facts.indirection.terminus

    files.each do |file|
      facts = YAML.load_file(file)

      request = Puppet::Indirector::Request.new(:facts, :save, facts)

      # The terminus warns for us if we fail.
      if terminus.save(request)
        Puppet.info "Uploaded facts for #{facts.name} to inventory service"
      else
        failed = true
      end
    end

    exit !failed
  end
end

Puppet::Application::UploadFacts.new.run
