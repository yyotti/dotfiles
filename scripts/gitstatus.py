#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import distutils.util
import os
import shutil
import subprocess
import sys


# TODO(Y.Tsutsui) subprocess部分の非同期化を検討
def main():
    if not shutil.which('git'):
        return 1

    if len(sys.argv) > 1 and os.path.isdir(sys.argv[1]):
        os.chdir(sys.argv[1])

    ret = subprocess.run(['git', 'rev-parse', '--git-dir',
                          '--is-inside-git-dir', '--is-bare-repository',
                          '--is-inside-work-tree', 'HEAD'],
                         universal_newlines=True,
                         stdout=subprocess.PIPE, stderr=subprocess.DEVNULL)
    if ret.returncode != 0:
        return 0

    [git_dir, in_gitdir, bare, in_wtree, sha] = ret.stdout.strip().splitlines()
    is_inside_gitdir = distutils.util.strtobool(in_gitdir)
    is_bare_repo = distutils.util.strtobool(bare)
    is_inside_worktree = distutils.util.strtobool(in_wtree)

    [operation, branch, is_detached] = get_operation_branch(git_dir,
                                                            is_inside_worktree,
                                                            sha)

    is_dirty = False
    staged_state = 0
    has_stashed = False
    has_untracked = False
    if is_inside_worktree:
        ret = subprocess.run(['git', 'config', '--bool', '--get-regexp',
                              '^bash\.(showDirtyState|showUntrackedFiles)$'],
                             universal_newlines=True,
                             stdout=subprocess.PIPE)
        config = {}
        for line in ret.stdout.strip().splitlines():
            key, value = line.split(' ', 1)
            config[str(key).lower()] = distutils.util.strtobool(value)

        if config.get('bash.showdirtystate', True):
            ret = subprocess.run(['git', 'diff', '--no-ext-diff', '--quiet',
                                  '--exit-code'],
                                 universal_newlines=True,
                                 stdout=subprocess.PIPE,
                                 stderr=subprocess.DEVNULL)
            is_dirty = ret.returncode != 0
            if len(sha) > 0:
                ret = subprocess.run(['git', 'diff-index', '--cached',
                                      '--quiet', 'HEAD', '--'],
                                     universal_newlines=True,
                                     stdout=subprocess.PIPE,
                                     stderr=subprocess.DEVNULL)
                if ret.returncode != 0:
                    staged_state = 1
            else:
                staged_state = 2

        if config.get('bash.showuntrackedfiles', True):
            ret = subprocess.run(['git', 'ls-files', '--others',
                                  '--exclude-standard', '--error-unmatch',
                                  '--', '*'],
                                 universal_newlines=True,
                                 stdout=subprocess.DEVNULL,
                                 stderr=subprocess.DEVNULL)
            has_untracked = ret.returncode == 0

        has_stashed = os.access(os.path.join(git_dir, 'refs', 'stash'),
                                os.R_OK)
        [upstream_name, behind, ahead] = get_upstream()
    else:
        [upstream_name, behind, ahead] = ['', 0, 0]

    repo_type = 0  # normal
    if is_bare_repo:
        repo_type = 1
    elif is_inside_gitdir:
        repo_type = 2
    results = [':' + operation,
               branch.replace('refs/heads/', ''),
               repo_type,
               1 if is_detached else 0,
               1 if is_dirty else 0,
               staged_state,
               1 if has_stashed else 0,
               1 if has_untracked else 0,
               ':' + upstream_name, behind, ahead]
    print(' '.join([str(e) for e in results]))

    return 0


def get_operation_branch(git_dir, is_inside_worktree, sha):
    branch = ''
    step = -1
    total = -1
    operation = ''
    is_detached = False
    if os.path.isdir(os.path.join(git_dir, 'rebase', 'merge')):
        branch = _read_quiet(os.path.join(git_dir,
                                          'rebase-merge', 'head-name'))
        step = _to_int(_read_quiet(os.path.join(git_dir,
                                                'rebase-merge', 'msgnum')), -1)
        total = _to_int(_read_quiet(os.path.join(git_dir,
                                                 'rebase-merge', 'end')), -1)
        if os.path.isfile(os.path.join(git_dir,
                                       'rebase-merge', 'interactive')):
            operation = '|REBASE-i'
        else:
            operation = '|REBASE-m'
    else:
        if os.path.isdir(os.path.join(git_dir, 'rebase-apply')):
            step = _to_int(_read_quiet(os.path.join(git_dir,
                                                    'rebase-apply', 'next')),
                           -1)
            total = _to_int(_read_quiet(os.path.join(git_dir,
                                                     'rebase-apply', 'last')),
                            -1)
            if os.path.isfile(os.path.join(git_dir,
                                           'rebase-apply', 'rebasing')):
                operation = '|REBASE'
            elif os.path.isfile(os.path.join(git_dir,
                                             'rebase-apply', 'applying')):
                operation = '|AM'
            else:
                operation = '|AM/REBASE'
        elif os.path.isfile(os.path.join(git_dir, 'MERGE_HEAD')):
            operation = '|MERGING'
        elif os.path.isfile(os.path.join(git_dir, 'CHERRY_PICK_HEAD')):
            operation = '|CHERRY-PICKING'
        elif os.path.isfile(os.path.join(git_dir, 'REVERT_HEAD')):
            operation = '|REVERTING'
        elif os.path.isfile(os.path.join(git_dir, 'BISECT_LOG')):
            operation = '|BISECTING'

    if step >= 0 and total >= 0:
        operation = '{} {}/{}'.format(operation, step, total)

    if len(branch) == 0:
        ret = subprocess.run(['git', 'symbolic-ref', 'HEAD'],
                             universal_newlines=True,
                             stdout=subprocess.PIPE, stderr=subprocess.DEVNULL)
        if ret.returncode == 0:
            branch = ret.stdout.strip()
        else:
            is_detached = True
            ret = subprocess.run(['git', 'describe',
                                  '--contains', '--all', 'HEAD'],
                                 universal_newlines=True,
                                 stdout=subprocess.PIPE,
                                 stderr=subprocess.DEVNULL)
            if ret.returncode == 0:
                branch = ret.stdout.strip()
            else:
                if len(sha) > 0:
                    branch = sha[0, 7]
                else:
                    branch = 'unknown'

    return [operation, branch, is_detached]


def get_upstream():
    ret = subprocess.run(['git', 'config', 'bash.showUpstream'],
                         universal_newlines=True,
                         stdout=subprocess.PIPE, stderr=subprocess.DEVNULL)

    ret = subprocess.run(['git', 'rev-list', '--count', '--left-right',
                          '@{upstream}...HEAD'],
                         universal_newlines=True,
                         stdout=subprocess.PIPE, stderr=subprocess.DEVNULL)
    if ret.returncode != 0:
        return ['', 0, 0]

    counts = ret.stdout.strip().split('\t')

    upstream_name = ''
    if len(counts) > 0:
        [behind, ahead] = counts
        ret = subprocess.run(['git', 'rev-parse', '--abbrev-ref',
                              '@{upstream}'],
                             universal_newlines=True,
                             stdout=subprocess.PIPE,
                             stderr=subprocess.DEVNULL)
        upstream_name = ret.stdout.strip()
    else:
        [behind, ahead] = [0, 0]

    return [upstream_name, behind, ahead]


def _read_quiet(filename):
    try:
        with open(filename) as f:
            content = f.read()
    except Exception:
        content = ''

    return content


def _to_int(s, default=-1):
    try:
        i = int(s)
    except Exception:
        i = default

    return i

if __name__ == '__main__':
    exit(main())
