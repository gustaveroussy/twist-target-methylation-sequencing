rule methyldackel_mbias:
    input:
        unpack(get_methyldackel_mbias_input)
    output:
        directory("methylome/QC/{sample}")
    threads: 1
    resources:
        mem_mb=lambda wildcards, attempt: (attempt * 5 * 1024) + (1024 * 45),
        runtime=lambda wildcards, attempt: (attempt * 60) + 90,
        tmpdir=tmpdir,
    log:
        "logs/methyldackel/mbias/{sample}.log"
    params:
        extra="",
    conda:
        "../../envs/methyldackel.yaml"
    shell:
        "MethylDackel mbias {params.extra} {input.fasta} {input.bam} {output} > {log} 2>&1"

rule methyldackel_mbias:
    input:
        unpack(get_methyldackel_mbias_input)
    output:
        directory("methylome/QC/{sample}")
    threads: 1
    resources:
        mem_mb=lambda wildcards, attempt: (attempt * 5 * 1024) + (1024 * 45),
        runtime=lambda wildcards, attempt: (attempt * 60) + 90,
        tmpdir=tmpdir,
    log:
        "logs/methyldackel/mbias/{sample}.log"
    params:
        extra="--minDepth 10 --maxVariantFrac 0.25 --OT X,X,X,X --OB X,X,X,X --mergeContext",
    conda:
        "../../envs/methyldackel.yaml"
    shell:
        "MethylDackel extract {params.extra} {input.fasta} {input.bam} {output} > {log} 2>&1"

