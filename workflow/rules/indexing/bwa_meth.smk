rule bwameth_index:
    input:
        fasta_path,
    output:
        temp(directory("bwameth/index")),
    threads: config.get("max_threads", 20)
    resources:
        mem_mb=lambda wildcards, attempt: (attempt * 5 * 1024) + (1024 * 45),
        runtime=lambda wildcards, attempt: (attempt * 60) + 90,
        tmpdir=tmpdir,
    log:
        "logs/bwameth/index.log",
    params:
        extra="",
    conda:
        "../../envs/bwameth.yaml"
    shell:
        "bwameth.py index-mem2 {params.extra} {input} > {log} 2>&1 "
