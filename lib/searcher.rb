class Searcher
  attr_accessor :names, :k, :hash_table
  
  def initialize(k)
    @k = k
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
  
  def find(s)
    b = find_in_table(s)
    @names[b]
  end
  
  private

  def find_in_table(s) # return closest match
    ids = Array.new
    kmers = kmers(s)
    kmers.each do |kmer|
      ids << hash_table[kmer] if hash_table.has_key? kmer
    end
    ids.flatten!
    best = ids.group_by{ |e| e }.values.max_by(&:size)
    best.first unless best.nil?
  end
    
  def kmers(s) # generate kmers from a string
    kmers = []
    steps = s.length - @k + 1
    steps.times do |n|
      kmer = s[n..n+K]
      kmers << kmer
    end
    kmers
  end
  
end