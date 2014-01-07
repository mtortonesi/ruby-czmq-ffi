# ruby-czmq-ffi

ruby-czmq-ffi provides low-level Ruby bindings for the
[CZMQ](http://czmq.zeromq.org/) library. ruby-czmq-ffi leverages the FFI
mechanism, and thus works on all the main Ruby VMs: YARV/MRI, JRuby, and
Rubinius.

The ruby-czmq-ffi library was not designed to be used directly by applications,
but instead to provide functions for higher-level gems such as
[ruby-czmq](https://github.com/mtortonesi/ruby-czmq).


## Installation

I have not released ruby-czmq-ffi on RubyGems, yet. For the moment, if you want
to try ruby-czmq-ffi just place this line:

```ruby
gem ruby-czmq-ffi, git: 'https://github.com/mtortonesi/ruby-czmq-ffi'
```

in your Gemfile and run:

    bundle install


## License

MIT
