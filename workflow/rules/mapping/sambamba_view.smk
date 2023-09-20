rule sambamba_view:
    input:
        "bwameth/mapping/{sample}.sam",
    output:
        temp("sambamba/view/{sample}.filtered.bam")
    threads: config.get("max_threads", 10)
    resources:
        mem_mb=lambda wildcards, attempt: attempt * 1024 + 1024 * 3,
        runtime=lambda wildcards, attempt: attempt * 30 + 20,
        tmpdir=tmpdir,
    params:
        extra=(
            "--format bam "
            "--filter "
            "'not secondary_alignment and "
            "not failed_quality_control and "
            "not supplementary and proper_pair and "
            "mapping_quality > 0'"
        )
    log:
        "logs/sambamba-view/{sample}.log"
    wrapper:
        f"{snakemake_wrappers_version}/bio/sambamba/view"