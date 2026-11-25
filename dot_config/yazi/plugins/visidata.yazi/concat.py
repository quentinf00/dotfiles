#!/usr/bin/env python3
"""Combine selected tables/JSON for VisiData, or JSON records for fx."""
import argparse
import csv
import json
import os
from pathlib import Path
import subprocess
import sys
import tempfile

SOURCE = '_source_file'
LABEL = '_source_label'
JSON_SUFFIXES = ('.json', '.jsonl', '.ndjson')


def json_records(paths):
    paths = [Path(os.path.abspath(p)) for p in paths]
    common = Path(os.path.commonpath([str(p.parent) for p in paths]))
    for path in paths:
        try:
            with path.open(encoding='utf-8-sig') as stream:
                if path.suffix.lower() in ('.jsonl', '.ndjson'):
                    values = (json.loads(line) for line in stream if line.strip())
                    yield from labelled_records(values, path, common)
                else:
                    value = json.load(stream)
                    yield from labelled_records(value if isinstance(value, list) else [value], path, common)
        except ValueError as exc:
            raise ValueError('%s: %s' % (path, exc)) from exc


def labelled_records(values, path, common):
    for value in values:
        if not isinstance(value, dict):
            raise ValueError('expected an object or an array/JSONL of objects')
        if SOURCE in value or LABEL in value:
            raise ValueError('reserved source column name')
        yield {LABEL: str(path.relative_to(common)), SOURCE: str(path), **value}


def flatten(value, prefix='', result=None):
    result = {} if result is None else result
    for key, item in value.items():
        # Escape dots and backslashes so nested and literal dotted keys stay distinct.
        escaped = key.replace('\\', '\\\\').replace('.', '\\.')
        name = prefix + escaped
        if isinstance(item, dict) and item:
            flatten(item, name + '.', result)
        else:
            result[name] = json.dumps(item, ensure_ascii=False) if isinstance(item, (list, dict)) else item
    return result


def combine_json(paths, output, jsonl=False):
    if output.resolve() in [Path(p).resolve() for p in paths]:
        raise ValueError('Output must not overwrite an input')
    # Validate all inputs before publishing a comparison, retaining JSON types for fx.
    records = list(json_records(paths))
    if jsonl:
        text = ''.join(json.dumps(row, ensure_ascii=False, allow_nan=False) + '\n' for row in records)
        output.write_text(text, encoding='utf-8')
    else:
        rows = [flatten(row) for row in records]
        fields = list(dict.fromkeys([LABEL, SOURCE] + [key for row in rows for key in row]))
        with output.open('w', newline='', encoding='utf-8') as dest:
            writer = csv.DictWriter(dest, fieldnames=fields)
            writer.writeheader()
            writer.writerows(rows)
    return len(records)


def combine(paths, output):
    paths = [Path(os.path.abspath(p)) for p in paths]
    if paths and all(p.suffix.lower() in JSON_SUFFIXES for p in paths):
        return combine_json(paths, output)
    headers = []
    for path in paths:
        with path.open(newline='', encoding='utf-8-sig') as f:
            fields = next(csv.reader(f, delimiter='\t' if path.suffix.lower() == '.tsv' else ','), [])
        if not fields or len(fields) != len(set(fields)):
            raise ValueError('%s: missing or duplicate column names' % path)
        if SOURCE in fields or LABEL in fields:
            raise ValueError('%s: reserved source column name' % path)
        headers.extend(x for x in fields if x not in headers)
    common = Path(os.path.commonpath([str(p.parent) for p in paths]))
    if output.resolve() in [p.resolve() for p in paths]:
        raise ValueError('Output must not overwrite an input')
    count = 0
    with output.open('w', newline='') as dest:
        writer = csv.DictWriter(dest, fieldnames=[LABEL, SOURCE] + headers)
        writer.writeheader()
        for path in paths:
            label = str(path.relative_to(common))
            with path.open(newline='', encoding='utf-8-sig') as f:
                reader = csv.DictReader(f, delimiter='\t' if path.suffix.lower() == '.tsv' else ',')
                for row in reader:
                    if None in row:
                        raise ValueError('%s: row has more values than its header' % path)
                    writer.writerow(dict(row, **{LABEL: label, SOURCE: str(path)}))
                    count += 1
    return count


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output', type=Path, help='Write combined CSV (or JSONL for fx) without opening viewer')
    parser.add_argument('--viewer', choices=('vd', 'fx'), default='vd')
    parser.add_argument('paths', nargs='+')
    args = parser.parse_args()
    try:
        paths = [os.path.abspath(p) for p in args.paths]
        is_json = all(Path(p).suffix.lower() in JSON_SUFFIXES for p in paths)
        if args.viewer == 'fx':
            if args.output:
                if not is_json:
                    raise ValueError('JSONL comparison requires JSON/JSONL inputs')
                combine_json(paths, args.output, jsonl=True)
                return 0
            if len(paths) == 1:
                if Path(paths[0]).suffix.lower() in ('.jsonl', '.ndjson'):
                    with open(paths[0], 'rb') as stream:
                        return subprocess.call(['fx'], stdin=stream)
                flags = ['--yaml'] if Path(paths[0]).suffix.lower() in ('.yaml', '.yml', '.lock') else []
                return subprocess.call(['fx'] + flags + paths)
            if not is_json:
                raise ValueError('Select JSON/JSONL files together for an fx comparison')
            with tempfile.TemporaryDirectory(prefix='yazi-fx-') as folder:
                output = Path(folder) / 'comparison.jsonl'
                combine_json(paths, output, jsonl=True)
                # fx 39 treats a positional .jsonl filename as a JS expression.
                # Its stream reader accepts JSONL on stdin in interactive mode.
                with output.open('rb') as stream:
                    return subprocess.call(['fx'], stdin=stream)
        if args.output:
            combine(args.paths, args.output)
            return 0
        if len(args.paths) == 1 or not (is_json or all(Path(p).suffix.lower() in ('.csv', '.tsv') for p in args.paths)):
            # Other formats use vd's normal multi-sheet opening; no internal API.
            return subprocess.call(['vd'] + [os.path.abspath(p) for p in args.paths])
        with tempfile.TemporaryDirectory(prefix='yazi-visidata-') as folder:
            output = Path(folder) / 'comparison.csv'
            combine(args.paths, output)
            return subprocess.call(['vd', str(output)])
    except (OSError, ValueError) as exc:
        print(args.viewer + ' comparison: ' + str(exc), file=sys.stderr)
        return 1


if __name__ == '__main__':
    sys.exit(main())
