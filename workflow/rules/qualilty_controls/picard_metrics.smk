rule picard_collect_multiple_metrics:
    input:
        unpack(get_picard_collect_multiple_metrics_input)
    output:
        multiext(
            "picard/collectmultiplemetrics/{sample}",
            ".alignment_summary_metrics",
            ".insert_size_metrics",
            ".insert_size_histogram.pdf",
            ".gc_bias.detail_metrics",
            ".gc_bias.summary_metrics",
            ".gc_bias.pdf",
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
        "v2.6.0/bio/picard/collectmultiplemetrics"


rule picard_collect_hs_metrics:
    input:
        unpack(get_picard_collect_hs_metrics_input)
    output:
        "picard/collecthsmetrics/hs_metrics/{sample}.txt",
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
        "v2.6.0/bio/picard/collecthsmetrics"