#!/usr/bin/env python3
# coding: utf-8

import pandas
import yaml

from typing import Dict, Union

def load_nb(path: str) -> int:
    """
    Return read number given in provided file path
    """
    with open(file=path, mode="r") as yaml_stream:
        return yaml.load(stream=yaml_stream, Loader=yaml.SafeLoader)


design: pandas.DataFrame() = snakemake.params["design"]

design.to_csv(
    path_or_buf=snakemake.output.design_backup, 
    sep="\t", 
    header=True, 
    index=False
)

panel: Dict[str, Union[int, Dict[str, int]]] = load_nb(snakemake.input[0])

design["Subsampling"] = [
    int(
        (
            design["panel"]["size"] * 250
        ) / (
            panel["samples"][sample]["mean_read_length"] * panel["samples"][sample]["nb_reads"]
        )
    )
    for sample in design.Sample_id
]

design.to_csv(
    path_or_buf=snakemake.output.design_updated,
    sep="\t",
    header=True,
    index=False
)