require 'czmq-ffi/libc'

module Utils
  def self.extract_string(ffi_str_pointer)
    # Make sure we don't try to extract a string from a NULL pointer.
    return nil if ffi_str_pointer.null? # || ffi_str_pointer.nil?

    # Read the string pointed by ffi_str_pointer.
    str = ffi_str_pointer.read_string

    # The read_string method (actually, the str_new C function nested
    # inside it) makes a deep copy, so we can safely free ffi_str_pointer.
    LibC.free(ffi_str_pointer)

    # Return the string we extracted from ffi_str_pointer.
    str
  end
end
