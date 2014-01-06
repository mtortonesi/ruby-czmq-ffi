require 'ffi'

CZMQ_FFI_LIB_PATH = File.expand_path(File.dirname(__FILE__))
$LOAD_PATH.unshift(CZMQ_FFI_LIB_PATH) unless $LOAD_PATH.include?(CZMQ_FFI_LIB_PATH)

require 'ruby-czmq-ffi/constants'
require 'ruby-czmq-ffi/libczmq'
require 'ruby-czmq-ffi/version'
