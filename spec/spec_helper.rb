$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rspec'
require 'signal-delay/global'
require 'object-channel'

def set_traps_to_transmit_over named_channel, *signals
  signals = Signal.list.keys if signals.empty?
  signals.each do |signal|
    begin
      Signal.trap signal do 
        begin
          Object.const_get(named_channel).transmit("trapped:#{signal}")
        rescue Object => e
          puts e.inspect
        end
      end
    rescue ArgumentError
      return false
    end
    return true
  end
end
