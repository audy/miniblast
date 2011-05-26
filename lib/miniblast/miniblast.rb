require 'benchmark'

class Miniblast
  attr_accessor :names, :k, :hash_table
  
  def initialize(args={})
    @k = args[:k]
    @names = Hash.new
    @hash_table = Hash.new { |h, k| h[k] = Array.new }  
  end
  
  def add(sequence, name) # add a sequence to the database
    id = @names.keys.length + 1
    @names[id] = name
    kmers(sequence).each do |kmer|
      @hash_table[kmer] << id
    end
  end
  
  def load(handle, args={}) # load an entire database
    File.open(handle) do |handle|
      db = DnaIO.new handle
      db.each do |record|
        self.add(record.sequence, record.name)
      end
    end
  end
  
  def find(s) # find
    b = find_in_table(s)
    @names[b]
  end
  
  def size # return size of database
    @hash_table.keys.length
  end
  
  private

  def find_in_table(s) # return closest match
    kmers = kmers(s)

    ids = Array.new
    kmers.each do |kmer|
      ids << hash_table[kmer] if hash_table.has_key? kmer
    end
    
    ids.flatten!

    best = ids.group_by{ |e| e }.values.max_by(&:size)
    best.first unless best.nil?
  end
    
  def kmers(s) # generate kmers from a string
    kmers = []
    steps = s.length - @k
    steps.times do |n|
      kmer = s[n, K]
      kmers << kmer
    end
    kmers
  end
  
end