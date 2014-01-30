require 'ffi'
require 'czmq-ffi/constants'

module LibCZMQ

  class ZPollItem < FFI::Struct
    FD_TYPE = if FFI::Platform::IS_WINDOWS && FFI::Platform::ADDRESS_SIZE == 64
      # On Windows, zmq.h defines fd as a SOCKET, which is 64 bits on x64.
      :uint64
    else
      :int
    end

    layout  :socket,  :pointer,
            :fd,      FD_TYPE,
            :events,  :short,
            :revents, :short

    def readable?
      (self[:revents] & CZMQ::POLLIN) > 0
    end

    def writable?
      (self[:revents] & CZMQ::POLLOUT) > 0
    end

    def inspect
      "socket [#{self[:socket]}], fd [#{self[:fd]}], events [#{self[:events]}], revents [#{self[:revents]}]"
    end
  end

  def self.create_pollitem(args={})
    pi = ZPollItem.new
    pi[:socket]  = args[:socket]
    pi[:fd]      = args[:fd] || 0
    pi[:events]  = args[:events] || 0
    pi[:revents] = args[:revents] || 0
    pi
  end

end
