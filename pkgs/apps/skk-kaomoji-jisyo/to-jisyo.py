# encoding:utf-8

import argparse
import csv
import os
import subprocess
import tempfile

first_lines = """\
;; Kaomoji dictionary for SKK system
;;
;; okuri-ari entries.
;; okuri-nasi entries.
"""


def main(args=None):
    collect = {}
    with open(args.input_file, "r") as f:
        reader = csv.reader(f, delimiter="\t")
        next(reader)
        for row in reader:
            kaomoji = row[0]
            categories = row[1].split(" ")
            for category in categories:
                if category in collect.keys():
                    collect[category].append(kaomoji)
                else:
                    collect[category] = [kaomoji]
    results = []
    total = "かおもじ "
    for k, v in collect.items():
        results.append("\n".join(map(lambda x: f"{k} /{x}/", v)))
        total += "/" + "/".join(v) + "/"
    results.sort()
    with open("tmp.jisyo", "w", encoding="utf-8") as f:
        f.write(first_lines + "\n".join(results) + f"\n{total}")

    subprocess.run("yaskkserv2_make_dictionary --utf8 --dictionary-filename ./tmp.yaskkserv2 tmp.jisyo", shell=True)
    subprocess.run(
        f"yaskkserv2_make_dictionary --utf8 --dictionary-filename ./tmp.yaskkserv2 --output-jisyo-filename {args.output_file}",
        shell=True,
    )
    subprocess.run(f'sed -i -e "2s/yaskkserv2/Kaomoji/g" {args.output_file}', shell=True)
    # エラーを発声させる顔文字の削除
    subprocess.run(f'sed -i -e "$ s/( ^)o(^ )\\/\\///g" {args.output_file}', shell=True)
    os.remove("./tmp.jisyo")
    os.remove("./tmp.yaskkserv2")


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--input_file", type=str, default="emoticon.tsv")
    parser.add_argument("--output_file", type=str, default="SKK-JISYO.kaomoji.utf8")
    args = parser.parse_args()
    main(args)
