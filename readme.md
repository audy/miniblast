# MiniBLAST

The usual seed and extend search algorithm implemented in Ruby.

    miniblast database.fasta query.fasta [kmer_length]

## What it do?

  - Finds you a string that has the closest matching substring to your query string.
	- Uses all your cores
	- Is fast
	
## What it don't?

  - Compute alignments
	- Do any fancy heuristics to ensure biologically relevant results