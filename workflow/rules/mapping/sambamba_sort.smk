rule sambamba_sort:
    input:
        "sambamba/view/{sample}.bam",
    output:
        temp("sambamba/sort/{sample}.sorted.bam"),
    threads: config.get("max_threads", 10)
    resources:
        mem_mb=lambda wildcards, attempt: attempt * 1024 + 1024 * 3,
        runtime=lambda wildcards, attempt: attempt * 30 + 20,
        tmpdir=tmpdir,
    params:
        "",
    log:
        "logs/sambamba/sort/{sample}.log",
    wrapper:
        f"{snakemake_wrappers_version}/bio/sambamba/sort"
