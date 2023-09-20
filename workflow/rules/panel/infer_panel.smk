rule bedtools_merge:
    input:
        expand(
            "picard/markduplicates/{sample}.bam",
            sample=design.Sample_id
        )
    output:
        temp("panel/mapped.bed")
    threads: 1
    resources:
        mem_mb=lambda wildcards, attempt: attempt * 1024 + 1024 * 3,
        runtime=lambda wildcards, attempt: attempt * 30 + 20,
        tmpdir=tmpdir,
    log:
        "logs/bedtools/merge/panel.log"
    params:
        extra=""
    wrapper:
        f"{snakemake_wrappers_version}/bio/bedtools/merge"
