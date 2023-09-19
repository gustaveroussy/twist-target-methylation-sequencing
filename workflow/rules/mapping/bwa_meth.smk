rule bwameth_index:
    input:
        idx="bwameth/index",
        r1="trim_galore/reads/{sample}_R1.fq.gz",
        r2="trim_galore/reads/{sample}_R2.fq.gz",
    output:
        temp("bwameth/mapping/{sample}.sam"),
    threads: config.get("max_threads", 20)
    resources:
        mem_mb=lambda wildcards, attempt: (attempt * 5 * 1024) + (1024 * 45),
        runtime=lambda wildcards, attempt: (attempt * 60) + 90,
        tmpdir=tmpdir,
    log:
        "logs/bwameth/mapping/{sample}.log"
    params:
        extra="--read-group '@RG\{sample}:1\tPL:illumina\tLB:{sample}\tSM:{sample}'",
    conda:
        "../../envs/bwameth.yaml"
    shell:
        "bwameth.py --reference {input.idx} -t {threads} {params.extra} {r1} {r2} > {log} 2>&1"