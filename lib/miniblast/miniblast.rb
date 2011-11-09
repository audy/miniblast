require 'rubygems'
require 'snappy'
require 'redis'

class Miniblast
  attr_accessor :names, :k, :hash_table, :database
  
  def initialize(args={})
    @k = args[:k]
    @names = Hash.new
    
    
    @redis = Redis.new
    
    @hash_table = Hash.new { |h, k| h[k] = Array.new }
    @database = Hash.new # save original sequences
    @sizes = Hash.new # compressed sequence sizes
    @id_posn = 0 # id counter for making ids
  end
  
  # add a sequence to the database
  def add(sequence, name)
    
    # make a new id
    id = @id_posn += 1
    
    @names[id] = name # name of sequence
    @database[id] = sequence # the sequence itself
     
    # generate kmers and add them to db
    # O of L/K
    (sequence.length - @k).times do |n|
      kmer = sequence[n, @k]
      # O?
      @redis.sadd kmer, id
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
      ids << @redis.smembers(kmer) if @redis.exists? kmer
    end
    
    ids.flatten!

    best = ids.group_by{ |e| e }.values.max_by(&:size)
    best.first unless best.nil?
  end
 
end
