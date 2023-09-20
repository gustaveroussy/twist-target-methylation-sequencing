rule samtools_index:
    input:
        "{tool}/{subcommand}/{sample}.sorted.bam"
    output:
        temp("{tool}/{subcommand}/{sample}.sorted.bam.bai"),
    threads: config.get("max_threads", 10)
    resources:
        mem_mb=lambda wildcards, attempt: attempt * 1024 + 1024 * 3,
        runtime=lambda wildcards, attempt: attempt * 30 + 20,
        tmpdir=tmpdir,
    log:
        "logs/samtools/index/{sample}.log",
    params:
        extra="",
    wrapper:
        f"{snakemake_wrappers_version}/bio/samtools/index"