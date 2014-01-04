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
end
