#!/usr/bin/env python3
"""Validates JMTE template block nesting (foreach/if → end)."""
import re
import sys

TAG_RE = re.compile(r'\$\{(foreach|if|else|end)(?:\s[^}]*)?\}')


def validate(filename):
    with open(filename, encoding='utf-8') as f:
        lines = f.readlines()

    stack = []
    errors = []

    for lineno, line in enumerate(lines, 1):
        for match in TAG_RE.finditer(line):
            tag = match.group(1)
            if tag in ('foreach', 'if'):
                stack.append((tag, lineno))
            elif tag == 'else':
                if not stack or stack[-1][0] != 'if':
                    errors.append(f'  line {lineno}: unexpected ${{else}}')
            elif tag == 'end':
                if not stack:
                    errors.append(f'  line {lineno}: unexpected ${{end}}')
                else:
                    stack.pop()

    for tag, lineno in stack:
        errors.append(f'  line {lineno}: unclosed ${{{tag}}}')

    if errors:
        print(f'{filename}:')
        for e in errors:
            print(e)
        return False
    return True


if __name__ == '__main__':
    results = [validate(f) for f in sys.argv[1:]]
    sys.exit(0 if all(results) else 1)
