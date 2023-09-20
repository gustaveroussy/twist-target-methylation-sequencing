rule multiqc:
    input:
        expand(
            "picard/collectmultiplemetrics/{sample}{ext}",
            sample=design.Sample_id,
            ext=[
                ".alignment_summary_metrics",
                ".insert_size_metrics",
                ".insert_size_histogram.pdf",
                ".gc_bias.detail_metrics",
                ".gc_bias.summary_metrics",
                ".gc_bias.pdf",
            ]
        ),
        expand(
            "picard/collecthsmetrics/hs_metrics/{sample}.txt",
            sample=design.Sample_id,
        ),
        expand(
            "qc/fastqc/{sample}_{stream}.html",
            sample=design.Sample_id,
            stream=["R1", "R2"],
        ),
        expand(
            "qc/fastqc/{sample}_{stream}_fastqc.zip",
            sample=design.Sample_id,
            stream=["R1", "R2"],
        ),
        expand(
            "trim_galore/reports/{sample}_{stream}_trimming_report.txt",
            sample=design.Sample_id,
            stream=["R1", "R2"],
        ),
        expand(
            "picard/metrics/{sample}.metrics.txt",
            sample=desig.Sample_id,
        )
    output:
        "multiqc/QC/Report.html"
    params:
        extra=""
    log:
        "logs/multiqc.log"
    wrapper:
        f"{snakemake_wrappers_version}/bio/multiqc"