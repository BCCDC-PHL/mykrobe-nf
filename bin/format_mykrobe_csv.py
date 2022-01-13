#!/usr/bin/env python

import argparse
import csv
import json
import sys

def parse_mykrobe_csv(mykrobe_csv, mykrobe_fieldnames):
    mykrobe = []
    with open(mykrobe_csv, 'r') as f:
        reader = csv.DictReader(f, fieldnames=mykrobe_fieldnames)
        next(reader) # skip header
        for row in reader:
            row['lineage'] = row['lineage'].replace('lineage', '')
            mykrobe.append(row)

    return mykrobe


def main(args):
    mykrobe_fieldnames = [
        "sample",
        "drug",
        "susceptibility",
        "variants",
        "genes",
        "mykrobe_version",
        "files",
        "probe_sets",
        "genotype_model",
        "kmer_size",
        "phylo_group",
        "species",
        "lineage",
        "phylo_group_per_covg",
        "species_per_covg",
        "lineage_per_covg",
        "phylo_group_depth",
        "species_depth",
        "lineage_depth",
    ]

    mykrobe = parse_mykrobe_csv(args.mykrobe_csv, mykrobe_fieldnames)
    
    writer = csv.DictWriter(sys.stdout, fieldnames=mykrobe_fieldnames)
    writer.writeheader()
    for row in mykrobe:
        writer.writerow(row)

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('mykrobe_csv')
    args = parser.parse_args()
    main(args)
