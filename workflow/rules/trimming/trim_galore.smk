rule trim_galore:
    input:
        expand(
            "data_input/{sample}.{stream}.fq.gz",
            stream=["R1", "R2"],
            allow_missing=True,
        )
    output:
        fasta_fwd=temp("trim_galore/reads/{sample}_R1.fq.gz"),
        report_fwd=temp("trim_galore/reports/{sample}_R1_trimming_report.txt"),
        fasta_rev=temp("trim_galore/reads/{sample}_R2.fq.gz"),
        report_rev=temp("trim_galore/reports/{sample}_R2_trimming_report.txt"),
    threads: config.get("max_threads", 20)
    resources:
        mem_mb=lambda wildcards, attempt: attempt * 1024 + 1024 * 3,
        runtime=lambda wildcards, attempt: attempt * 30 + 20,
        tmpdir=tmpdir,
    params:
        extra=" --paired ",
    log:
        "logs/trim_galore/{sample}.log",
    wrapper:
        f"{snakemake_wrappers_version}/bio/trim_galore/pe"