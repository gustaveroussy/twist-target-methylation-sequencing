rule markduplicates_bam:
    input:
        bams="sambamba/sort/{sample}.sorted.bam",
        bai="sambamba/sort/{sample}.sorted.bam.bai",
    output:
        bam="picard/markduplicates/{sample}.bam",
        metrics=temp("picard/metrics/{sample}.metrics.txt"),
    threads: 1
    resources:
        mem_mb=lambda wildcards, attempt: attempt * 1024 + 1024 * 3,
        runtime=lambda wildcards, attempt: attempt * 30 + 20,
        tmpdir=tmpdir,
    log:
        "logs/picard/markduplicates/{sample}.log",
    params:
        extra=(
            "--MAX_RECORDS_IN_RAM 1000 "
            "--SORTING_COLLECTION_SIZE_RATIO 0.15 "
            "--ASSUME_SORT_ORDER coordinate "
            "--OPTICAL_DUPLICATE_PIXEL_DISTANCE 2500"
        ),
    wrapper:
        f"{snakemake_wrappers_version}/bio/picard/markduplicates"