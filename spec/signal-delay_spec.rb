require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe 'Signal.delay' do
  after :each do
    Object.class_eval{ remove_const :NamedChannel } if Object.const_defined? :NamedChannel
  end
  Signal.list.keys.select do |signal|
    next false if [
      'KILL',
      'STOP',
      'VTALRM',
      'EXIT'
    ].include? signal
    next true
  end.each do |signal|

    it "should be able to delay <#{signal}>" do
      pid = ObjectChannel.fork :NamedChannel do
        begin
          set_traps_to_transmit_over :NamedChannel, signal
          NamedChannel.transmit 'initial traps set'
          NamedChannel.receive! # continue

          Signal.delay(signal) do
            NamedChannel.transmit 'signals delayed'
            5.times do
              NamedChannel.receive! # signal sent
              sleep 0.01
              NamedChannel.transmit 'signal ignored'
            end
            NamedChannel.receive! # continue
            NamedChannel.transmit 'done'
          end
          sleep 0.01
          NamedChannel.transmit 'outside'
        rescue Object => e
          NamedChannel.transmit "raised: <#{e}>\n#{e.backtrace rescue nil}"
        ensure
          exit! # prevent RSpec from catching fork's exit
        end
      end

      NamedChannel.receive!.should == 'initial traps set'

      2.times do
        Process.kill(signal,pid)
        NamedChannel.receive!.should == "trapped:#{signal}"
      end
      
      NamedChannel.transmit 'continue'
      
      NamedChannel.receive!.should == 'signals delayed'
      
      5.times do
        Process.kill(signal,pid)
        NamedChannel.transmit 'signal'
        NamedChannel.receive!.should == 'signal ignored'
      end
      
      NamedChannel.transmit 'continue'
      NamedChannel.receive!.should == 'done'
      sleep 0.01
      NamedChannel.receive!.should == "trapped:#{signal}"

      if Gem::Version.create(RUBY_VERSION.dup) < Gem::Version.create('1.9')
        4.times do
          NamedChannel.receive!.should == "trapped:#{signal}"
        end
      end

      NamedChannel.receive!.should == 'outside'
    end
  end
end
