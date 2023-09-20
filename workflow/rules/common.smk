import pandas
import snakemake

from typing import Any, Dict, List, Union

if config == {}:
    configfile: "config/config.yaml"

design_path = config.get("design", "config/desig.tsv")
design: pandas.DataFrame = pandas.read_csv(
    filepath_or_buffer=design_path,
    sep="\t",
    header=0,
    index_col=0,
)
design["Sample_id"] = desig.index.tolist()

snakemake_wrappers_version: str = "v2.6.0"

################################
### Paths to reference files ###
################################

# Main genome informations
species: str = config.get("reference", {}).get("species", "homo_sapiens")
build: str = config.get("reference", {}).get("build", "GRCh38")
release: str = config.get("reference", {}).get("release", "109")

fasta_path: str = f"reference/{species}.{build}.{release}.fasta"
fasta_index_path: str = f"reference/{species}.{build}.{release}.fasta.fai"
fasta_dict_path: str = f"reference/{species}.{build}.{release}.dict"


def get_picard_bed_to_interval_list_input(wildcards: snakemake.io.Wildcards, config: Dict[str, Any] = config) -> Dict[str, str]:
    """
    Return path to expected interval list and sequence dictionary
    """
    return {
        "bed": config.get("resources", {}).get("panel") or "panel/mapped.bed",
        "dict": fasta_dict_path,
    }


def get_fastq_trim_galore_input(wildcards: snakemake.io.Wildcards, design: pandas.DataFrame = design) -> List[str]:
    """
    Return list of expected fastq files
    """
    return [
        design["Upstream_file"].loc[wildcards.sample],
        design["Downstream_file"].loc[wildcards.sample],
    ]


def get_fastq_seqkit_input(wildcards: snakemake.io.Wildcards, design: pandas.DataFrame = design) -> List[str]:
    """
    Return expected fastq file
    """
    if str(wildcards.stream).lower() == "r1":
        return design["Upstream_file"].loc[wildcards.sample]
    
    return design["Downstream_file"].loc[wildcards.sample]


def get_methylation_targets(config: Dict[str, Any] = config) -> Dict[str, Union[str, List[str]]]:
    """
    Return methylation analysis results
    """
    expected_targets = {}
    steps = config.get("steps", {"install": False, "mapping": True})
    if steps.get("install", False):
        expected_targets["fasta"] = fasta_path
        expected_targets["fasta_index"] = fasta_index_path
        expected_targets["fasta_dict"] = fasta_dict_path
    
    if steps.get("mapping", False):
        expected_targets["mapped"] = expand(
            "picard/markduplicates/{sample}.bam",
            sample=design.Sample_id
        )
        expected_targets["QC"] = "multiqc/QC/Report.html"

    if steps.get("calling", False):
        expected_targets["meth_mbias"] = expand(
            "methylome/QC/{sample}",
            sample=design.Sample_id
        )
        expected_targets["meth_extract"] = expand(
            "methylome/extract/{sample}",
            sample=design.Sample_id
        )
        expected_targets["meth_report"] = expand(
            "methylome/report/{sample}",
            sample=design.Sample_id
        )

    return expected_targets


def get_subsampling_targets(config: Dict[str, Any] = config) -> Dict[str, Union[str, List[str]]]:
    """
    Return subsampling results
    """
    pass