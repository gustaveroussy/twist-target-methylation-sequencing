rule bwameth_index:
    input:
        ref=fasta_path,
        ref_idx=fasta_index_path,
    output:
        temp(bwameth_indexes),
    threads: config.get("max_threads", 20)
    resources:
        mem_mb=lambda wildcards, attempt: (attempt * 20 * 1024) + (1024 * 126),
        runtime=lambda wildcards, attempt: max((attempt * 45) + 90, 60 * 3),
        tmpdir=tmpdir,
    log:
        "logs/bwameth/index.log",
    params:
        extra="",
    conda:
        "../../envs/bwameth.yaml"
    shell:
        "bwameth.py index-mem2 {params.extra} {input.ref} > {log} 2>&1 "
