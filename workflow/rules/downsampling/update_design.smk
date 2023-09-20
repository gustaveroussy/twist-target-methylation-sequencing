rule cat_seq_info:
    input:
        panel="panel/merged_probe_size.txt",
        sample=expand(
            "panel/read_nb/{sample}.txt",
            sample=design.Sample_id,
        ),
    output:
        temp("panel/complete_data.yaml"),
    threads: 1
    resources:
        mem_mb=lambda wildcards, attempt: attempt * 1024,
        runtime=lambda wildcards, attempt: attempt * 30,
        tmpdir=tmpdir,
    log:
        "logs/cat_seq_info.log",
    params:
        echo_panel='-e "panel:\n"',
        echo_sample='-e "\nsamples:\n"',
        cat="",
    conda:
        "../../envs/awk.yaml"
    shell:
        "echo {params.echo_panel} > {output} 2> {log} && "
        "cat {input.panel} >> {output} 2>> {log} && "
        "echo {params.echo_sample} >> {output} 2>> {log} && "
        "cat {input.sample_size} >> {output} 2>> {log} "


rule update_design:
    input:
        "panel/complete_data.yaml",
    output:
        design_updated=config.get("design", "design.tsv"),
        design_backup="backup.design.tsv",
    threads: 1
    resources:
        mem_mb=lambda wildcards, attempt: attempt * 1024,
        runtime=lambda wildcards, attempt: attempt * 30,
        tmpdir=tmpdir,
    log:
        "logs/update_design.log",
    params:
        design=design.copy(),
    conda:
        "../../envs/python.yaml"
    script:
        "../../scripts/update_design.py"
