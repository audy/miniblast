# MiniBLAST

The usual seed and extend search algorithm implemented in Ruby.

    miniblast database.fasta query.fasta [kmer_length]

This is a pet project of mine. Instead of getting a Chevy z28 or a pair of really slick roller skates, I hack away at my DNA sequence searching program.

## What it do?

- Finds you a string that has the largest matching substring to your query string.
- Uses all your cores.
- Is fast.
	
## What it don't?

- Provide any information about the quality of the match given.