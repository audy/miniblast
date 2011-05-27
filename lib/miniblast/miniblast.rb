require 'benchmark'
require 'snappy'
require 'trie'

class Miniblast
  attr_accessor :names, :k, :hash_table, :database
  
  def initialize(args={})
    @k = args[:k]
    @names = Hash.new
    @hash_table = Hash.new { |h, k| h[k] = Array.new }
    @database = Hash.new # save original sequences
    @sizes = Trie.new # compressed sequence sizes
  end
  
  # add a sequence to the database
  def add(sequence, name)
    id = (@names.keys.length + 1) # saves memory, but slow
    @names[id] = name
    @database[id] = sequence
    kmers(sequence).each do |kmer|
      @hash_table[kmer] << id
    end
  end
  
  # load an entire database
  def load(handle, args={})
    File.open(handle) do |handle|
      db = DnaIO.new handle
      db.each do |record|
        self.add(record.sequence, record.name)
      end
    end
  end
  
  # search database for a similar sequence
  # return name and score
  def find(s)
    id = find_in_table(s)
    unless id.nil?
      h = {:name => @names[id], :score => score(s, @database[id])}
    else
      nil
    end
  end
  
  # return size of database
  def size
    @hash_table.keys.length
  end
  
  # score query sequence to database sequence similarity using compression
  def score(s, d)
    i, j, k = deflate(s).length, deflate(d).length, deflate(s + d).length
    # how to calculate significance of similarity?
    k < (i + j)
  end
  
  private

  # deflate a string using gzip compression
  def deflate(s)
    Snappy.compress(s)
  end

  # return closest match
  def find_in_table(s)
    kmers = kmers(s)

    ids = Array.new
    kmers.each do |kmer|
      ids << hash_table[kmer] if hash_table.has_key? kmer
    end
    
    ids.flatten!

    best = ids.group_by{ |e| e }.values.max_by(&:size)
    best.first unless best.nil?
  end
    
  # generate kmers from a string
  def kmers(s)
    kmers = []
    steps = s.length - @k
    steps.times do |n|
      kmer = s[n, K]
      kmers << kmer
    end
    kmers
  end
  
end