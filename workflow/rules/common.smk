import pandas
import snakemake

from typing import Any, Dict

def get_panel(config: Dict[str, Any] = config):
    """
    Return path to panel if provided, else return path to
    inferred panel from bam files.
    """
    return config.get("resources", {}).get("panel") or "panel/mapped.bed"


def get_fasta(config: Dict[str, Any] = config) -> str:
    """
    Return path to provided fasta file, if any.
    Else, return path to downloaded fasta file.
    """
    species: str = config.get("reference", {}).get("species", "homo_sapiens")
    build: str = config.get("reference", {}).get("build", "GRCh38")
    release: str = config.get("reference", {}).get("release", "109")

    return config.get("resources", {}).get("fasta") or f"reference/{species}.{build}.{release}.fasta"


def get_fai(config: Dict[str, Any] = config) -> str:
    """
    Return path to provided fasta file, if any.
    Else, return path to index of downloaded fasta file.
    """
    species: str = config.get("reference", {}).get("species", "homo_sapiens")
    build: str = config.get("reference", {}).get("build", "GRCh38")
    release: str = config.get("reference", {}).get("release", "109")

    return config.get("resources", {}).get("fasta_fai") or f"reference/{species}.{build}.{release}.fasta.fai"


def get_fasta_dict(config: Dict[str, Any] = config) -> str:
    """
    Return path to provided fasta file, if any.
    Else, return path to index of downloaded fasta file.
    """
    species: str = config.get("reference", {}).get("species", "homo_sapiens")
    build: str = config.get("reference", {}).get("build", "GRCh38")
    release: str = config.get("reference", {}).get("release", "109")

    return config.get("resources", {}).get("fasta_dict") or f"reference/{species}.{build}.{release}.dict"



def get_fastq(wildcards: snakemake.io.Wildcards, design: pandas.DataFrame = design) -> str:
    """
    Return path to expected fastq file
    """
    if "stream" in wildcards.keys():
        if str(wildcards.stream).lower() == "r2":
            return design["Downstream_file"].loc[wildcards.sample]
    
    return design["Upstream_file"].loc[wildcards.sample]


def get_picard_bed_to_interval_list_input(wildcards: snakemake.io.Wildcards, config: Dict[str, Any] = config) -> Dict[str, str]:
    """
    Return path to expected interval list and sequence dictionary
    """
    return {
        "bed": get_panel(config),
        "dict": get_fasta_dict(config),
    }


def get_picard_collect_multiple_metrics_input(wildcards: snakemake.io.Wildcards, config: Dict[str, Any] = config) -> Dict[str, str]:
    """
    Return path to expected fasta genome sequence and bam mapped reads
    """
    return {
        "ref": get_fasta(config),
        "bam": "picard/markduplicates/{sample}.bam",
    }


def get_picard_collect_hs_metrics_input(wildcards: snakemake.io.Wildcards, config: Dict[str, Any] = config) -> Dict[str, str]:
    """
    Return path to expected fasta genome sequence, bam mapped reads, and intervals
    """
    paths = get_picard_collect_multiple_metrics_input(wildcards, config)
    paths.update(**{
        "bait_intervals": "picard/bedtointervallist/bait.intervals",
        "target_intervals": "picard/bedtointervallist/target.intervals",
    })
    
    return paths


def get_fastq_trim_galore(wildcards: snakemake.io.Wildcards, design: pandas.DataFrame = design) -> List[str]:
    """
    Return list of expected fastq files
    """
    return [
        design["Upstream_file"].loc[wildcards.sample],
        design["Downstream_file"].loc[wildcards.sample],
    ]

def get_methyldackel_mbias_input(wildcards: snakemake.io.Wildcards, config: Dict[str, Any]) -> Dict[str, str]:
    """
    Return path to genome fasta sequence and bam mapped reads.
    """
    return {
        "fasta": get_fasta(config),
        "fai": get_fai(config),
        "bam": "picard/markduplicates/{sample}.bam",
    }