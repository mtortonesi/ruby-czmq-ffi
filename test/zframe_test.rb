require 'test_helper'

describe LibCZMQ do

  describe 'zframe' do

    it 'should be able to create empty zframes' do
      zframe = LibCZMQ.zframe_new
      LibCZMQ.zframe_size(zframe).must_equal 0
    end

    it 'should be able to create zframes from an (int) array' do
      zframe = LibCZMQ.zframe_new([ 1, 2, 3, 4, 5, 6 ])
      LibCZMQ.zframe_size(zframe).must_equal 6
    end

  end

end
