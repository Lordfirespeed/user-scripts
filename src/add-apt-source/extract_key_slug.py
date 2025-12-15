import re
import sys


def validate_lines_are_gpg_show_keys_output(lines: list[str]) -> None:
    def fail():
        raise Exception("Input should be piped from `gpg --show-keys`, provided input doesn't match expected structure.'")

    if not (4 <= len(lines) <= 5):
        raise Exception(f"Input should be piped from `gpg --show-keys` on a keyring containing exactly one key.\nTherefore, input should be 4-5 lines long, but got {len(lines)} lines.")
    if not lines[0].startswith("pub"): fail()
    if not lines[1].startswith(" "): fail()
    if not lines[2].startswith("uid"): fail()
    if len(lines) > 4 and not lines[3].startswith("sub"): fail()
    if lines[-1] != "\n": fail()


def extract_key_uid_from_gpg_show_keys_output(lines: list[str]) -> str:
    uid_line = lines[2]
    uid = uid_line[3:].strip()
    return uid


def normalise_key_uid_to_slug(uid: str) -> str:
    lower_uid = uid.lower()
    slug = re.sub(r"[\s_]+", "-", lower_uid)
    return slug


def main():
    stdin_lines = [l for l in sys.stdin]
    validate_lines_are_gpg_show_keys_output(stdin_lines)
    uid = extract_key_uid_from_gpg_show_keys_output(stdin_lines)
    slug = normalise_key_uid_to_slug(uid)
    print(slug)


if __name__ == "__main__":
    main()
