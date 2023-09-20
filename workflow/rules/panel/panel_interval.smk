rule picard_bed_to_interval_list:
    input:
        unpack(get_picard_bed_to_interval_list_input)
    output:
        temp("picard/bedtointervallist/target.intervals"),
    threads: 1
    resources:
        mem_mb=lambda wildcards, attempt: attempt * 1024 + 1024 * 3,
        runtime=lambda wildcards, attempt: attempt * 30 + 20,
        tmpdir=tmpdir,
    log:
        "logs/picard/bedtointervallist.log",
    params:
        extra="--SORT true",
    wrapper:
        f"{snakemake_wrappers_version}/bio/picard/bedtointervallist"


rule rsync_target_to_bait:
    input:
        "picard/bedtointervallist/target.intervals",
    output:
        temp("picard/bedtointervallist/bait.intervals"),
    threads: 1
    resources:
        mem_mb=lambda wildcards, attempt: attempt * 1024 + 1024,
        runtime=lambda wildcards, attempt: attempt * 30,
        tmpdir=tmpdir,
    log:
        "logs/rsync/target_to_bait.log"
    params:
        extra="-cvrhP",
    conda:
        "../../envs/awk.yaml"
    shell:
        "rsync {params.extra} {input} {output} > {log} 2>&1"