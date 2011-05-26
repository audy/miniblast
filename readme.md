# MiniBLAST

The usual seed and extend search algorithm implemented in Ruby.

    miniblast database.fasta query.fasta [kmer_length]

## What it do?

- Finds you a string that has the largest matching substring to your query string.
- Uses all your cores
- Is fast (faster than megablast)
	
## What it don't?

- Compute alignments
- Tell how _how_ similar your sequence is to the matching sequence (who would want to do that?).
- Do any fancy heuristics to ensure biologically relevant results