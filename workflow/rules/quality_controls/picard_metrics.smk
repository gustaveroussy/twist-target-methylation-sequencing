rule picard_collect_multiple_metrics:
    input:
        ref=fasta_path,
        bam="picard/markduplicates/{sample}.bam",
    output:
        temp(
            multiext(
                "picard/collectmultiplemetrics/{sample}",
                ".alignment_summary_metrics",
                ".insert_size_metrics",
                ".insert_size_histogram.pdf",
                ".gc_bias.detail_metrics",
                ".gc_bias.summary_metrics",
                ".gc_bias.pdf",
            )
        ),
    threads: 1
    resources:
        mem_mb=lambda wildcards, attempt: attempt * 1024 + 1024 * 3,
        runtime=lambda wildcards, attempt: attempt * 30 + 20,
        tmpdir=tmpdir,
    log:
        "logs/picard/multiple_metrics/{sample}.log",
    params:
        extra="--VALIDATION_STRINGENCY LENIENT",
    wrapper:
        f"{snakemake_wrappers_version}/bio/picard/collectmultiplemetrics"


rule picard_collect_hs_metrics:
    input:
        refefrence=fasta_path,
        reference_fai=fasta_index_path,
        reference_dict=fasta_dict_path,
        bam="picard/markduplicates/{sample}.bam",
        bait_intervals="picard/bedtointervallist/bait.intervals",
        target_intervals="picard/bedtointervallist/target.intervals",
    output:
        temp("picard/collecthsmetrics/hs_metrics/{sample}.txt"),
    threads: 1
    resources:
        mem_mb=lambda wildcards, attempt: attempt * 1024 + 1024 * 3,
        runtime=lambda wildcards, attempt: attempt * 30 + 20,
        tmpdir=tmpdir,
    params:
        extra=" --MINIMUM_MAPPING_QUALITY 20 --COVERAGE_CAP 1000 --NEAR_DISTANCE 500 ",
    log:
        "logs/picard_collect_hs_metrics/{sample}.log",
    wrapper:
        f"{snakemake_wrappers_version}/bio/picard/collecthsmetrics"
