# MiniBLAST

The usual seed and extend search algorithm implemented in Ruby.

    miniblast database.fasta query.fasta [kmer_length]

This is a pet project of mine. Instead of getting a Chevy z28 or a pair of really slick roller skates, I hack away at my DNA sequence searching program.

## What it do?

- Finds you a string that has the largest matching substring to your query string.
- Uses all your cores (and memory).
- Is fast.
	
## What it don't?

- Provide any information about the quality of the match given 'cause who needs that?

## Requirements

- Ruby 1.8.7 or 1.9.2 (if you want to go _faaast!_)
- [Parallel](https://github.com/grosser/parallel)
- [snappy-ruby](https://github.com/delta407/snappy-ruby)
- [ruby-trie](https://github.com/jaronson/ruby-trie)