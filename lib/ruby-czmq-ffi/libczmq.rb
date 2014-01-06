module LibCZMQ
  extend FFI::Library

  begin
    # This looks like a sensible search path
    LIB_PATH = %w{/usr/lib /usr/lib64 /usr/local/lib /usr/lib32}
    CZMQ_LIB_PATH = LIB_PATH.map{ |path| "#{path}/libczmq.#{FFI::Platform::LIBSUFFIX}" }
    ffi_lib(CZMQ_LIB_PATH + %w{libzmq})
  rescue LoadError
    warn "Could not load czmq library."
    raise
  end

  attach_function :zctx_new, [], :pointer
  attach_function :zctx_destroy, [:pointer], :void
  attach_function :zctx_set_io_threads, [:pointer, :int], :void
  attach_function :zctx_set_linger, [:pointer, :int], :void
  attach_function :zctx_set_pipehwm, [:pointer, :int], :void
  attach_function :zctx_set_sendhwm, [:pointer, :int], :void
  attach_function :zctx_set_recvhwm, [:pointer, :int], :void
  attach_function :zctx_underlying, [:pointer], :pointer

  attach_function :zbeacon_new, [:int], :pointer
  attach_function :zbeacon_destroy, [:pointer], :void
  attach_function :zbeacon_hostname, [:pointer], :pointer
  attach_function :zbeacon_set_interval, [:pointer, :int], :void
  attach_function :zbeacon_noecho, [:pointer], :void
  attach_function :zbeacon_publish, [:pointer, :pointer, :size_t], :void
  attach_function :zbeacon_silence, [:pointer], :void
  attach_function :zbeacon_subscribe, [:pointer, :pointer, :size_t], :void
  attach_function :zbeacon_unsubscribe, [:pointer], :void
  attach_function :zbeacon_socket, [:pointer], :pointer

  attach_function :zsocket_new, [:pointer, :int], :pointer
  attach_function :zsocket_destroy, [:pointer], :void
  attach_function :zsocket_bind, [:pointer, :string, :varargs], :void
  attach_function :zsocket_unbind, [:pointer, :string, :varargs], :void
  attach_function :zsocket_connect, [:pointer, :string, :varargs], :void
  attach_function :zsocket_disconnect, [:pointer, :string, :varargs], :void
  attach_function :zsocket_poll, [:pointer, :int], :bool
  attach_function :zsocket_type_str, [:pointer], :pointer
  attach_function :zsocket_sendmem, [:pointer, :pointer, :size_t, :int], :int
end
