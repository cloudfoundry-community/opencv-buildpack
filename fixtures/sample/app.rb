#!/usr/bin/env ruby
require "webrick"

puts "Redis: #{`redis-cli -v`}"

server = WEBrick::HTTPServer.new(:Port => (ENV['PORT'] || 8080))
server.mount_proc '/' do |req, res|
  res.body = "Redis: #{`redis-cli -v`}"
end

trap("INT") { server.shutdown }
server.start
