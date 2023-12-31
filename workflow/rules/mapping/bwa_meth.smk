rule bwameth_mapping:
    input:
        idx=bwameth_indexes,
        fasta=fasta_path,
        fai=fasta_index_path,
        r1="trim_galore/reads/{sample}_R1.fq.gz",
        r2="trim_galore/reads/{sample}_R2.fq.gz",
    output:
        temp("bwameth/mapping/{sample}.sam"),
    threads: config.get("max_threads", 20)
    resources:
        mem_mb=lambda wildcards, attempt: (attempt * 20 * 1024) + (1024 * 30),
        runtime=lambda wildcards, attempt: (attempt * 45) + 90,
        tmpdir=tmpdir,
    log:
        "logs/bwameth/mapping/{sample}.log",
    params:
        extra="--read-group '@RG\tID:{sample}\tPL:illumina\tLB:{sample}\tSM:{sample}'",
    conda:
        "../../envs/bwameth.yaml"
    shell:
        "bwameth.py --reference {input.fasta} -t {threads} {params.extra} {input.r1} {input.r2} > {output} 2> {log}"
