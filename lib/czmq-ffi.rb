require 'ffi'

CZMQ_FFI_LIB_PATH = File.expand_path(File.dirname(__FILE__))
$LOAD_PATH.unshift(CZMQ_FFI_LIB_PATH) unless $LOAD_PATH.include?(CZMQ_FFI_LIB_PATH)

require 'czmq-ffi/constants'
require 'czmq-ffi/libczmq'
require 'czmq-ffi/version'
