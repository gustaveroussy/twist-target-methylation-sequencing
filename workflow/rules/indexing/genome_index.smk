rule samtools_faidx:
    input:
        "reference/{species}.{build}.{release}.fasta"
    output:
        "reference/{species}.{build}.{release}.fasta.fai",
    threads: 1
    resources:
        mem_mb=lambda wildcards, attempt: attempt * 1024 + 1024 * 3,
        runtime=lambda wildcards, attempt: attempt * 30 + 20,
        tmpdir=tmpdir,
    log:
        "logs/samtools/faidx/{species}.{build}.{release}.log",
    params:
        extra="",
    wrapper:
        "v2.6.0/bio/samtools/faidx"


rule create_dict:
    input:
        "reference/{species}.{build}.{release}.fasta"
    output:
        "reference/{species}.{build}.{release}.dict"
    threads: 1
    resources:
        mem_mb=lambda wildcards, attempt: attempt * 1024 + 1024 * 3,
        runtime=lambda wildcards, attempt: attempt * 30 + 20,
        tmpdir=tmpdir,
    log:
        "logs/picard/create_dict/{species}.{build}.{release}.log",
    params:
        extra="",
    wrapper:
        "v2.6.0/bio/picard/createsequencedictionary"