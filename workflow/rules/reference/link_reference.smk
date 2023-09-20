rule link_fasta_sequence:
    input:
        config["reference"]["fasta"],
    output:
        "reference/{species}.{build}.{release}.fasta",
    threads: 2
    resources:
        mem_mb=lambda wildcards, attempt: attempt * 512,
        runtime=lambda wildcards, attempt: attempt * 60 * 24,
        tmpdir=tmp,
    log:
        "logs/ln/fasta_sequence.log",
    params:
        extra="-sfr",
    conda:
        "../../envs/bash.yaml"
    shell:
        "ln {params.extra} {input} {output} > {log} 2>&1"
