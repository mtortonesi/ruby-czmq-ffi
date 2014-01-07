require 'czmq-ffi/utils'

module LibCZMQ
  extend FFI::Library

  begin
    # This looks like a sensible search path
    LIB_PATH = %w{/usr/lib /usr/lib64 /usr/local/lib /usr/lib32}
    CZMQ_LIB_PATH = LIB_PATH.map{ |path| "#{path}/libczmq.#{FFI::Platform::LIBSUFFIX}" }
    ffi_lib(CZMQ_LIB_PATH + %w{libzmq})
  rescue LoadError
    warn "Could not load the CZMQ Library."
    raise
  end

  attach_function :zctx_new, [], :pointer
  attach_function :__zctx_destroy, :zctx_destroy, [:pointer], :void
  attach_function :zctx_set_iothreads, [:pointer, :int], :void
  attach_function :zctx_set_linger, [:pointer, :int], :void
  attach_function :zctx_set_pipehwm, [:pointer, :int], :void
  attach_function :zctx_set_sndhwm, [:pointer, :int], :void
  attach_function :zctx_set_rcvhwm, [:pointer, :int], :void
  attach_function :zctx_underlying, [:pointer], :pointer

  def self.zctx_destroy(zctx)
    zctx_ptr = FFI::MemoryPointer.new(:pointer)
    zctx_ptr.write_pointer(zctx)
    __zctx_destroy(zctx_ptr)
  end


  attach_function :zbeacon_new, [:int], :pointer
  attach_function :__zbeacon_destroy, :zbeacon_destroy, [:pointer], :void
  attach_function :zbeacon_hostname, [:pointer], :pointer
  attach_function :zbeacon_set_interval, [:pointer, :int], :void
  attach_function :zbeacon_noecho, [:pointer], :void
  attach_function :zbeacon_publish, [:pointer, :pointer, :size_t], :void
  attach_function :zbeacon_silence, [:pointer], :void
  attach_function :zbeacon_subscribe, [:pointer, :pointer, :size_t], :void
  attach_function :zbeacon_unsubscribe, [:pointer], :void
  attach_function :zbeacon_socket, [:pointer], :pointer

  def self.zbeacon_destroy(zbeacon)
    zbeacon_ptr = FFI::MemoryPointer.new(:pointer)
    zbeacon_ptr.write_pointer(zbeacon)
    __zbeacon_destroy(zbeacon_ptr)
  end


  attach_function :zsocket_new, [:pointer, :int], :pointer
  attach_function :zsocket_destroy, [:pointer, :pointer], :void
  attach_function :zsocket_bind, [:pointer, :string, :varargs], :int
  attach_function :zsocket_unbind, [:pointer, :string, :varargs], :void
  attach_function :zsocket_connect, [:pointer, :string, :varargs], :void
  attach_function :zsocket_disconnect, [:pointer, :string, :varargs], :void
  attach_function :zsocket_poll, [:pointer, :int], :bool
  attach_function :__zsocket_type_str, :zsocket_type_str, [:pointer], :pointer
  attach_function :zsocket_sendmem, [:pointer, :pointer, :size_t, :int], :int

  # return nil or (a copy of) the zsocket type name
  def self.zsocket_type_str(zsocket)
    type_ptr = __zsocket_type_str(zsocket)
    type_ptr.null? ? nil : type_ptr.read_string
  end


  attach_function :__zstr_recv, :zstr_recv, [:pointer], :pointer
  attach_function :__zstr_recv_nowait, :zstr_recv_nowait, [:pointer], :pointer
  attach_function :zstr_send, [:pointer, :string, :varargs], :int
  attach_function :zstr_sendm, [:pointer, :string, :varargs], :int
  attach_function :zstr_sendx, [:pointer, :string, :varargs], :int
  attach_function :zstr_recvx, [:pointer, :pointer, :varargs], :int

  def self.zstr_recv(zsocket)
    Utils.extract_string(__zstr_recv(zsocket))
  end

  def self.zstr_recv_nowait(zsocket)
    Utils.extract_string(__zstr_recv_nowait(zsocket))
  end

end
