#!/usr/bin/env python

'''Use the path suffixed with '-push' for outbounds operations.
'''

from mercurial import extensions, commands, help

def _outbound_with_suffix(orig, ui, repo, dest=None, *opts, **kwopts):
    if dest is not None:
        dest = ui.config('paths', dest + '-push', dest)
    orig(ui, repo, dest, *opts, **kwopts)

def _bundle_with_suffix(orig, ui, repo, fname, dest=None, *opts, **kwopts):
    if dest is not None:
        dest = ui.config('paths', dest + '-push', dest)
    orig(ui, repo, fname, dest, *opts, **kwopts)

def uisetup(ui):
    extensions.wrapcommand(commands.table, 'push', _outbound_with_suffix)
    extensions.wrapcommand(commands.table, 'outgoing', _outbound_with_suffix)
    extensions.wrapcommand(commands.table, 'bundle', _outbound_with_suffix)

testedwith = '2.2.3'