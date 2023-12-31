rule rename_input_files_paired:
    output:
        temp("data_input/{sample}.{stream}.fq.gz"),
    threads: 1
    resources:
        mem_mb=lambda wildcards, attempt: attempt * 1024,
        runtime=lambda wildcards, attempt: attempt * 15,
        tmpdir=tmpdir,
    log:
        "logs/rename_concat/{sample}.{stream}.log",
    params:
        input=lambda wildcards: get_fastq_seqkit_input(wildcards, design),
    conda:
        "../../envs/python.yaml"
    script:
        "../../scripts/indexing/rename.py"
