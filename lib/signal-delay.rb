require 'signal-delay/version'

module Signal
  module Delay

    extend self

    def delay(*signals, &block)
      signals = Signal.list.keys if signals.empty?
      begin
        signal_queue  = Array.new
        trap_cache    = Hash.new
        signals.each do |signal|
          begin
            trap_cache[signal] = Signal.trap(signal) do
              signal_queue.push(signal)
            end
          rescue ArgumentError # Some traps cannot be set.
            # SIGVTALRM - reserved by Ruby for thread-switching
          end
          nil
        end

        yield

      ensure
        trap_cache.each_pair { |*trap| Signal.trap(*trap) }
        Process.kill(signal_queue.shift,Process.pid) until signal_queue.empty?
      end  
    end
  end
end
