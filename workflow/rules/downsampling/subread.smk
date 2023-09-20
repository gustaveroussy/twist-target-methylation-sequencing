rule seqtk_sample_fastq:
    input:
        fastx="data_input/{sample}.{stream}.fq.gz",
    output:
        fastx=temp("gunzip/fastq/{sample}_{stream}.fastq"),
    threads: 1
    resources:
        mem_mb=lambda wildcards, attempt: attempt * 1024 + 1024 * 3,
        runtime=lambda wildcards, attempt: attempt * 30 + 20,
        tmpdir=tmpdir,
    params:
        command="sample",
        extra=lambda wildcards: f"--rand-seed 42 --two-pass --number {get_reads_nb(wildcards.sample)}",
    log:
        "logs/seqkit/subsample/{sample}_{stream}.log",
    wrapper:
        f"{snakemake_wrappers_version}/bio/seqkit"
