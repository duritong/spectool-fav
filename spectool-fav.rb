#!/usr/bin/env ruby

def perror(msg)
  puts red(msg)
  exit 1
end

def colorize(text, color_code)
    "\e[#{color_code}m#{text}\e[0m"
end

def run_cmd(pre,cmd)
  print "#{pre} "
  output = `#{cmd}`
  if $?.to_i > 0
    puts red("failed")
    puts
    perror("Output:\n#{output}")
  end
  puts green('done')
end

def red(text); colorize(text, 31); end
def green(text); colorize(text, 32); end

specfile = ARGV.shift
force_dl = ARGV.shift == '--force-fetch'
perror "USAGE: #{$0} SPECFILE [--force-fetch]" if specfile.nil? || !File.exists?(specfile)
specfile = File.expand_path(specfile)

if File.basename(File.dirname(specfile)) != "SPECS"
  perror("ERROR: SPECFile #{specfile} is not in a SPECS directory. Doesn't look like a proper RPM tree")
end

base = File.dirname(File.dirname(specfile))
sourcesdir = File.join(base,'SOURCES')

checksum_file = File.join(base,"#{File.basename(specfile,'.spec')}.sources")
checksum_file_sig = "#{checksum_file}.asc"

perror("ERROR: Checksumfile #{checksum_file} does not exist!") unless File.exists?(checksum_file)
perror("ERROR: Checksum signature file #{checksum_file_sig} does not exist!") unless File.exists?(checksum_file)

run_cmd('Validating checksum signature',"gpg --verify #{checksum_file_sig} 2>&1")


checksums = Hash[File.read(checksum_file).split("\n").collect{|c| c.split(' ',2 ).reverse}]
perror("No checksums to check") if checksums.empty?
sources = `spectool -S #{specfile} | grep -E '^Source[0-9]+: http(s)?:\/\/'`.split("\n").collect{|s| s.split(' ',2).last }
filenames = sources.collect{|s| s.split('/').last }.uniq.sort

missing = filenames - checksums.keys
unless missing.empty?
  perror("Checksums missing for a few sources: #{missing.join(', ')}")
end

run_cmd('Fetching sources', "spectool -R -g#{force_dl ? ' -f': ''} #{specfile} 2>&1")

failing = []
print 'Verifying '
checksums.each do |file,checksum|
  require 'digest'
  failing << file if Digest::SHA512.file(File.join(sourcesdir,file)).hexdigest != checksum
end

unless failing.empty?
  puts red("failed")
  perror("ERROR: Checksum do not match for the following files: #{failing.join(', ')}")
end

puts green('done')
