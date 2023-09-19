rule fastqc:
    input:
        "trim_galore/reads/{sample}_{stream}.fq.gz"
    output:
        html="qc/fastqc/{sample}_{stream}.html",
        zip="qc/fastqc/{sample}_{stream}_fastqc.zip"
    threads: 1
    resources:
        mem_mb=lambda wildcards, attempt: attempt * 1024 + 1024 * 3,
        runtime=lambda wildcards, attempt: attempt * 30 + 20,
        tmpdir=tmpdir,
    params:
        extra = " --noextract "
    log:
        "logs/fastqc/{sample}.log"
    wrapper:
        "v2.6.0/bio/fastqc"