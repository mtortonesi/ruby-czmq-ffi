module CZMQ
  #  Socket types
  PAIR   = 0
  PUB    = 1
  SUB    = 2
  REQ    = 3
  REP    = 4
  XREQ   = 5
  XREP   = 6
  PULL   = 7
  PUSH   = 8
  XPUB   = 9
  XSUB   = 10
  DEALER = XREQ
  ROUTER = XREP
  STREAM = 11

  SocketTypeToNameMap = {
    PAIR   => 'PAIR',
    PUB    => 'PUB',
    SUB    => 'SUB',
    REQ    => 'REQ',
    REP    => 'REP',
    PULL   => 'PULL',
    PUSH   => 'PUSH',
    XREQ   => 'XREQ',
    XREP   => 'XREP',
    ROUTER => 'ROUTER',
    DEALER => 'DEALER',
    XPUB   => 'XPUB',
    XSUB   => 'XSUB',
    STREAM => 'STREAM',
  }
end
