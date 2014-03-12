# ruby-czmq-ffi

ruby-czmq-ffi provides low-level Ruby bindings for the
[CZMQ](http://czmq.zeromq.org/) library. ruby-czmq-ffi leverages the FFI
mechanism, and thus should work on all the main Ruby VMs: YARV/MRI, JRuby, and
Rubinius.

The ruby-czmq-ffi library was not designed to be used directly by applications,
but instead to provide functions for higher-level gems such as
[ruby-czmq](https://github.com/mtortonesi/ruby-czmq).


## Installation

### Stable version

You can get the stable version of ruby-czmq-ffi by installing the czmq-ffi gem from
RubyGems:

    gem install czmq-ffi

### Development version

If you want to try the development version of ruby-czmq-ffi, instead, just place
this line:

```ruby
gem ruby-czmq-ffi, git: 'https://github.com/mtortonesi/ruby-czmq-ffi.git'
```

in your Gemfile and run:

    bundle install


## License

MIT
