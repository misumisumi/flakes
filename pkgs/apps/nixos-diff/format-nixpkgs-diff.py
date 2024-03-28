import re
import sys

pname_version = re.compile(r"^(.+?)(-([0-9].*?))?$")
pname_hash = re.compile(r"(-([^-]*?))$")


def main(diff_txt):
    updates = [
      "## Update-packages\n", "| Package | From | To |", "| --- | --- | --- |"]
    adds = [
        "## New-packages\n", "| Package | Version |", "| --- | --- |"]
    removes = [
        "## Remove-packages\n", "| Package | Version |", "| --- | --- |"]

    up_linux = False
    up_systemd = False

    minor = False

    for line in diff_txt:
        line = re.sub(r"\t|\s", "", line)
        if "|" in line:
            from_pkg, to_pkg = line.split("|")
            flag = 0
            up_linux = True if "linux_header" in line else up_linux
            up_systemd = True if "systemd" in line else up_systemd
        elif "<" in line:
            from_pkg, to_pkg = line.split("<")
            flag = 1
        else:
            from_pkg, to_pkg = line.split(">")
            flag = 2
        result = []
        for i, pkg in enumerate([from_pkg, to_pkg]):
            if pkg != "":
                match = pname_version.search(pkg)
                if match.group(2) is None:
                    rematch = pname_hash.search(pkg)
                    if rematch is not None:
                        version = rematch.group(1)
                        pname = re.sub(f"{version}", "", match.group(1))
                    else:
                        version, pname = "", ""
                else:
                    version = match.group(2)
                    pname = match.group(1)
                version = re.sub(r"^-", "", version)
                result.append((pname, version))
        if flag == 0 and result[0][1] and result[1][1]:
            updates.append(
                f"| {result[0][0]} | {result[0][1]} | {result[1][1]} |")
            if pname == "linux_header":
                ver1 = result[0][1].split(".")
                ver2 = result[1][1].split(".")

                for i in range(min(len(ver1), len(ver2))):
                    if ver1[i] < ver2[i]:
                        if i == 0 or i == 1:
                            minor = True

        elif flag == 1 and result[0][1]:
            removes.append(f"| {result[0][0]} | {result[0][1]} |")
        elif flag == 2 and result[0][1]:
            adds.append(f"| {result[0][0]} | {result[0][1]} |")
    if minor:
        print("## This-is-Minor-Update-because-'linux-kernel'-updated\n")
    if up_linux or up_systemd:
        print("## Need-reboot-because-'linux'-or-'systemd'-updated\n")
    print("## Update-summary\n\n<details><summary>lists</summary>\n")
    for i in [updates, adds, removes]:
        if len(i) > 3:
            print("\n".join(i + [" "]))
    print("</details>\n")


if __name__ == "__main__":
    diff_txt = sys.stdin.readlines()
    main(diff_txt)
