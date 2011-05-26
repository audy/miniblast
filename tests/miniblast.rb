require 'test/unit'
require './lib/miniblast'

class MiniBlastTest < Test::Unit::TestCase
  include Miniblast
  
  def test_kmer_construction
    # test with k = 1
    miniblast = Miniblast.new :k => 1
    puts miniblast.kmers('austin')
  end
  
end