"""Build vocabulary from manifest files.

Each item in vocabulary file is a character.
"""
from __future__ import absolute_import
from __future__ import division
from __future__ import print_function

import argparse
import codecs
import functools
from collections import Counter

from data_utils.utility import read_manifest
from utils.utility import add_arguments, print_arguments

parser = argparse.ArgumentParser(description=__doc__)
add_arg = functools.partial(add_arguments, argparser=parser)
# yapf: disable
add_arg('count_threshold',  int,    0,  "Truncation threshold for char counts.")
add_arg('vocab_path',       str,    './dataset/zh_vocab.txt', "Filepath to write the vocabulary.")
add_arg('manifest_paths',   str,    './dataset/manifest.train,./dataset/manifest.dev,', "Filepaths of manifests for building vocabulary. You can provide multiple manifest files.")
# yapf: disable
args = parser.parse_args()


def count_manifest(counter, manifest_path):
    manifest_jsons = read_manifest(manifest_path)
    for line_json in manifest_jsons:
        for char in line_json['text']:
            counter.update(char)


def main():
    print_arguments(args)

    counter = Counter()
    manifest_paths = [path for path in args.manifest_paths.split(',')]
    for manifest_path in manifest_paths:
        count_manifest(counter, manifest_path)

    count_sorted = sorted(counter.items(), key=lambda x: x[1], reverse=True)
    with codecs.open(args.vocab_path, 'w', 'utf-8') as fout:
        for char, count in count_sorted:
            if count < args.count_threshold: break
            fout.write(char + '\n')


if __name__ == '__main__':
    main()
