rule rust_fastq_stats:
    input:
        "trim_galore/reads/{sample}_R1.fq.gz"
    output:
        temp("rust-bio/{sample}.yaml")
    threads: 1
    resources:
        mem_mb=lambda wildcards, attempt: attempt * 1024 + 1024,
        runtime=lambda wildcards, attempt: attempt * 30,
        tmpdir=tmpdir,
    log:
        "logs/rust-bio/fastq_stats/{sample}.log"
    params:
        