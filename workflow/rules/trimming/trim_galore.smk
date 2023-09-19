rule trim_galore:
    input:
        unpack(get_fastq_trim_galore),
    output:
        fasta_fwd="trim_galore/reads/{sample}_R1.fq.gz",
        report_fwd="trim_galore/reports/{sample}_R1_trimming_report.txt",
        fasta_rev="trim_galore/reads/{sample}_R2.fq.gz",
        report_rev="trim_galore/reports/{sample}_R2_trimming_report.txt",
    threads: config.get("max_threads", 20)
    resources:
        mem_mb=lambda wildcards, attempt: attempt * 1024 + 1024 * 3,
        runtime=lambda wildcards, attempt: attempt * 30 + 20,
        tmpdir=tmpdir,
    params:
        extra=" --2colour 20 ",
    log:
        "logs/trim_galore/{sample}.log",
    wrapper:
        "v2.6.0/bio/trim_galore/pe"