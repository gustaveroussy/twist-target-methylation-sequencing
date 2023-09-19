use bio::io::fastq;
use std::io;
println!("Libraries loaded.");

let sample = &snakemake.wildcards.sample;
println!("Working on {}", sample);

let mut reader = fastq::Reads::new(&snakemake.input);

let mut nb_reads = 0;
let mut nb_bases = 0;

while let Some(Ok(record)) = records.next() {
    nb_reads += 1;
    nb_bases += record.seq().len();
}

let _stdout_redirect = snakemake.redirect_stdout(&snakemake.output);
println!("  {}: ", sample);
println!("    nb_reads: {}", nb_reads);
println!("    mean_read_length: {}", nb_bases / nb_reads);