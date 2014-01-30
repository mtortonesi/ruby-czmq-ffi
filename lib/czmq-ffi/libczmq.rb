require 'czmq-ffi/utils'

module LibCZMQ
  extend FFI::Library

  begin
    # This looks like a sensible search path
    LIB_PATH = %w{/usr/lib /usr/lib64 /usr/local/lib /usr/lib32}
    CZMQ_LIB_PATH = LIB_PATH.map{ |path| "#{path}/libczmq.#{FFI::Platform::LIBSUFFIX}" }
    ffi_lib(CZMQ_LIB_PATH + %w{libzmq})
  rescue LoadError
    warn 'Could not load the CZMQ Library.'
    raise
  end

  ##################################################
  # zctx-related functions
  ##################################################
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


  ##################################################
  # zbeacon-related functions
  ##################################################
  attach_function :zbeacon_new, [:int], :pointer # zbeacon_new returns NULL in case of failure
  attach_function :__zbeacon_destroy, :zbeacon_destroy, [:pointer], :void
  attach_function :zbeacon_hostname, [:pointer], :pointer
  attach_function :zbeacon_set_interval, [:pointer, :int], :void
  attach_function :zbeacon_noecho, [:pointer], :void
  attach_function :__zbeacon_publish, :zbeacon_publish, [:pointer, :pointer, :size_t], :void
  attach_function :zbeacon_silence, [:pointer], :void
  attach_function :__zbeacon_subscribe, :zbeacon_subscribe, [:pointer, :pointer, :size_t], :void
  attach_function :zbeacon_unsubscribe, [:pointer], :void
  attach_function :zbeacon_socket, [:pointer], :pointer

  def self.zbeacon_destroy(zbeacon)
    zbeacon_ptr = FFI::MemoryPointer.new(:pointer)
    zbeacon_ptr.write_pointer(zbeacon)
    __zbeacon_destroy(zbeacon_ptr)
  end

  def self.zbeacon_publish(zbeacon, byte_array)
    FFI::MemoryPointer.new(:uint8, byte_array.size) do |p|
      p.write_array_of_int8(byte_array)
      __zbeacon_publish(zbeacon, p, byte_array.size)
    end
  end

  def self.zbeacon_subscribe(zbeacon, byte_array=nil)
    if byte_array.nil?
      __zbeacon_subscribe(zbeacon, nil, 0)
    else
      FFI::MemoryPointer.new(:uint8, byte_array.size) do |p|
        p.write_array_of_int8(byte_array)
        __zbeacon_subscribe(zbeacon, p, byte_array.size)
      end
    end
  end



  ##################################################
  # zsocket-related functions
  ##################################################
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


  ##################################################
  # zstr-related functions
  ##################################################
  attach_function :__zstr_recv, :zstr_recv, [:pointer], :pointer
  attach_function :__zstr_recv_nowait, :zstr_recv_nowait, [:pointer], :pointer
  attach_function :zstr_send, [:pointer, :string, :varargs], :int
  attach_function :zstr_sendm, [:pointer, :string, :varargs], :int
  attach_function :zstr_sendx, [:pointer, :string, :varargs], :int
  # attach_function :__zstr_recvx, :zstr_recvx, [:pointer, :pointer, :varargs], :int

  def self.zstr_recv(zsocket)
    Utils.extract_string(__zstr_recv(zsocket))
  end

  def self.zstr_recv_nowait(zsocket)
    Utils.extract_string(__zstr_recv_nowait(zsocket))
  end


  ##################################################
  # zmsg-related functions
  ##################################################
  attach_function :zmsg_new, [], :pointer
  attach_function :__zmsg_destroy, :zmsg_destroy, [:pointer], :void
  attach_function :zmsg_recv, [:pointer], :pointer
  attach_function :__zmsg_send, :zmsg_send, [:pointer, :pointer], :int
  attach_function :zmsg_size, [:pointer], :size_t
  attach_function :zmsg_content_size, [:pointer], :size_t

  # zframe add / remove
  # NOTE: zmsg_push will take ownership of zframe and destroy it at the end
  attach_function :zmsg_push, [:pointer, :pointer], :int
  attach_function :zmsg_pop, [:pointer], :pointer
  # NOTE: zmsg_append will take ownership of zframe and destroy it at the end
  attach_function :__zmsg_append, :zmsg_append, [:pointer, :pointer], :int

  # memory buffer add / remove
  attach_function :__zmsg_pushmem, :zmsg_pushmem, [:pointer, :buffer_in, :size_t], :int
  attach_function :__zmsg_addmem, :zmsg_addmem, [:pointer, :buffer_in, :size_t], :int

  # string add / remove
  attach_function :zmsg_pushstr, [:pointer, :string, :varargs], :int
  attach_function :zmsg_addstr, [:pointer, :string, :varargs], :int
  attach_function :__zmsg_popstr, :zmsg_popstr, [:pointer], :pointer

  # NOTE: zmsg_wrap will take ownership of zframe and destroy it at the end
  attach_function :zmsg_wrap, [:pointer, :pointer], :void
  attach_function :zmsg_unwrap, [:pointer], :pointer
  # NOTE: zmsg_remove will simply remove the zframe without destroying it
  attach_function :zmsg_remove, [:pointer, :pointer], :void
  attach_function :zmsg_first, [:pointer], :pointer
  attach_function :zmsg_next, [:pointer], :pointer
  attach_function :zmsg_last, [:pointer], :pointer

  # TODO: implement zmsg_encode and zmsg_decode?

  attach_function :zmsg_dup, [:pointer], :pointer
  attach_function :zmsg_dump, [:pointer], :void

  # These are very low-level functions. Still unsure whether czmq-ffi should provide them.
  # attach_function :zmsg_save, [:pointer, :pointer], :int
  # attach_function :zmsg_load, [:pointer, :pointer], :pointer
  # attach_function :zmsg_dump_to_stream, [:pointer, :pointer], :void

  # NOTE: zmsg_add is deprecated. No point in supporting it.
  # attach_function :zmsg_add, [:pointer, :pointer], :int

  def self.zmsg_destroy(zmsg)
    zmsg_ptr = FFI::MemoryPointer.new(:pointer)
    zmsg_ptr.write_pointer(zmsg)
    __zmsg_destroy(zmsg_ptr)
  end

  def self.zmsg_send(zmsg, zsocket)
    zmsg_ptr = FFI::MemoryPointer.new(:pointer)
    zmsg_ptr.write_pointer(zmsg)
    __zmsg_send(zmsg_ptr, zsocket)
  end

  # zmsg will take ownership of zframe and destroy it at the end
  def self.zmsg_append(zmsg, zframe)
    zframe_ptr = FFI::MemoryPointer.new(:pointer)
    zframe_ptr.write_pointer(zframe)
    __zmsg_append(zmsg, zframe_ptr)
  end

  def self.zmsg_pushmem(zmsg, byte_array)
    rc = nil
    FFI::MemoryPointer.new(:uint8, byte_array.size) do |p|
      p.write_array_of_int8(byte_array)
      rc = __zmsg_pushmem(zmsg, p, byte_array.size)
    end
    rc
  end

  def self.zmsg_addmem(zmsg, byte_array)
    rc = nil
    FFI::MemoryPointer.new(:uint8, byte_array.size) do |p|
      p.write_array_of_int8(byte_array)
      rc = __zmsg_addmem(zmsg, p, byte_array.size)
    end
    rc
  end

  def self.zmsg_popstr(zmsg)
    Utils.extract_string(__zmsg_popstr(zmsg))
  end


  ##################################################
  # zframe-related functions
  ##################################################
  attach_function :__zframe_new, :zframe_new, [:buffer_in, :size_t], :pointer
  attach_function :__zframe_new_empty, :zframe_new_empty, [], :pointer
  attach_function :__zframe_destroy, :zframe_destroy, [:pointer], :void
  attach_function :zframe_recv, [:pointer], :pointer
  attach_function :zframe_recv_nowait, [:pointer], :pointer
  attach_function :__zframe_send, :zframe_send, [:pointer, :pointer, :int], :int
  attach_function :zframe_size, [:pointer], :size_t
  attach_function :zframe_dup, [:pointer], :pointer
  attach_function :__zframe_strhex, :zframe_strhex, [:pointer], :pointer
  attach_function :__zframe_strdup, :zframe_strdup, [:pointer], :pointer
  attach_function :zframe_streq, [:pointer, :string], :bool
  attach_function :zframe_more, [:pointer], :int
  attach_function :zframe_set_more, [:pointer, :int], :void
  attach_function :zframe_eq, [:pointer, :pointer], :bool
  attach_function :zframe_reset, [:pointer, :buffer_in, :size_t], :void

  # These are very low-level functions. Still unsure whether czmq-ffi should provide them.
  # attach_function :zframe_data, [:pointer], :pointer
  # attach_function :zframe_fprint, [:pointer, :string, :pointer], :void
  # attach_function :zframe_print, [:pointer, :string], :void

  def self.zframe_new(byte_array=nil)
    if byte_array.nil?
      __zframe_new_empty
    else
      zframe = nil
      FFI::MemoryPointer.new(:uint8, byte_array.size) do |p|
        p.write_array_of_int8(byte_array)
        zframe = __zframe_new(p, byte_array.size)
      end
      zframe
    end
  end

  def self.zframe_destroy(zframe)
    zframe_ptr = FFI::MemoryPointer.new(:pointer)
    zframe_ptr.write_pointer(zframe)
    __zframe_destroy(zframe_ptr)
  end

  def self.zframe_send(zframe, zsocket, flags)
    zframe_ptr = FFI::MemoryPointer.new(:pointer)
    zframe_ptr.write_pointer(zframe)
    __zframe_send(zframe_ptr, zsocket, flags)
  end

  def self.zframe_strhex(zframe)
    Utils.extract_string(__zframe_strhex(zframe))
  end

  def self.zframe_strdup(zframe)
    Utils.extract_string(__zframe_strdup(zframe))
  end


  ##################################################
  # zpoller-related functions
  ##################################################
  attach_function :zpoller_new, [:pointer, :varargs], :pointer
  attach_function :__zpoller_destroy, :zpoller_destroy, [:pointer], :void
  attach_function :zpoller_wait, [:pointer, :int], :pointer
  attach_function :zpoller_expired, [:pointer], :bool
  attach_function :zpoller_terminated, [:pointer], :bool

  def self.zpoller_destroy(zpoller)
    zpoller_ptr = FFI::MemoryPointer.new(:pointer)
    zpoller_ptr.write_pointer(zpoller)
    __zpoller_destroy(zpoller_ptr)
  end


  ##################################################
  # zloop-related functions
  ##################################################
  attach_function :zloop_new, [], :pointer
  attach_function :__zloop_destroy, :zloop_destroy, [:pointer], :void
  callback :zloop_callback, [:pointer, :pointer, :pointer], :int
  attach_function :zloop_poller, [:pointer, :pointer, :zloop_callback, :pointer], :int
  attach_function :zloop_poller_end, [:pointer, :pointer], :void
  attach_function :zloop_set_tolerant, [:pointer, :pointer], :void
  callback :zloop_timer_callback, [:pointer, :int, :pointer], :int
  attach_function :zloop_timer, [:pointer, :size_t, :size_t, :zloop_timer_callback, :pointer], :int
  attach_function :zloop_timer_end, [:pointer, :pointer], :int
  attach_function :zloop_set_verbose, [:pointer, :bool], :void
  attach_function :zloop_start, [:pointer], :int

  def self.zloop_destroy(zloop)
    zloop_ptr = FFI::MemoryPointer.new(:pointer)
    zloop_ptr.write_pointer(zloop)
    __zloop_destroy(zloop_ptr)
  end

  def self.create_zloop_callback(func)
    FFI::Function.new(:int, [:pointer, :pointer, :pointer]) do |zloop, zpollitem, arg|
      func.call(zloop, zpollitem[:socket])
    end
  end

end
