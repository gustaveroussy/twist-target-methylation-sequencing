rule awk_merged_probe_fingerprint_size:
    input:
        unpack(get_panel),
    output:
        design=temp("panel/merged_probe_size.yaml"),
    threads: 1
    resources:
        mem_mb=lambda wildcards, attempt: attempt * 1024,
        runtime=lambda wildcards, attempt: attempt * 30,
        tmpdir=tmpdir,
    log:
        "logs/awk/merged_probe_fingerprint_size.log",
    params:
        script=workflow.source_path("../../scripts/panel_size.awk"),
    conda:
        "../../envs/awk.yaml"
    shell:
        "awk --file {params.script} {input} > {output} 2> {log}"
