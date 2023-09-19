rule gunzip_fastq:
    input:
        unpack(get_fastq)
    output:
        temp("gunzip/fastq/{sample}_{stream}.fastq")
    threads: 1
    resources:
        mem_mb=lambda wildcards, attempt: attempt * 1024 + 1024 * 3,
        runtime=lambda wildcards, attempt: attempt * 30 + 20,
        tmpdir=tmpdir,
    params:
        extra=lambda wildcards: f"--rand-seed 42 --two-pass --number {get_reads_nb(wildcards.sample)}",
    
    