require 'bundler'
Bundler.require(:default)

$script = JSON.parse File.read 'script.json'

b = Discordrb::Bot.new(
  token: ENV['TOKEN'],
  client_id: ENV['CLIENT_ID']
)

def pick(text)
  v = $script.select { |k, _| text.match?(Regexp.new(k)) }.to_a[0][1]
  return v.sample(1)[0] if v.class == Array
  v
end

is_first = false
b.message do |e|
  m = e.message
  t = m.text

  if t.downcase.include? 'toadbot diss'
    is_first = true
  end

  if m.channel.server.id == 644363718196592651
    e.respond pick 'CAGE'
  elsif m.author.id == 644350082048589844
    puts 'First: ' + is_first.to_s
    if is_first
      e.respond pick 'FIRST'
      is_first = false
    else
      e.respond pick t
    end
  elsif m.author.id == 165998239273844736
    if t.start_with? "%r "
      e.respond eval t[3..-1]
    elsif t.start_with? "%eval "
      eval t[5..-1]
    end
  end
end

puts "This bot's invite URL is #{b.invite_url}"

b.run true

while buf = Readline.readline('% ', true)
  s = buf.chomp
  if s.start_with? 'reload'
    $script = JSON.parse File.read 'script.json'
    puts 'Reloaded script file.'
  elsif s.start_with? 'quit', 'stop'
    b.stop
    exit
  elsif s.start_with? 'restart'
    b.stop
    exec 'ruby', $PROGRAM_NAME
  elsif s.start_with? 'irb'
    binding.irb
  elsif s == ''
    next
  else
    puts 'Command not found'
  end
end

b.join

# vim: et:ts=2:sw=2
