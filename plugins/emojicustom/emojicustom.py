from os.path import abspath, basename, dirname
from pathlib import Path
import re
import subprocess

import pelican

PLUGIN_ROOT = Path(dirname(dirname(abspath(__file__))))


def init(pelican_object):
    # Global emojis, prefix
    global pelimoji_prog, pelimoji_replace

    # And a regex pattern to find to avoid iterating
    pattern = "\:(?P<emoji>[a-zA-Z]*)\:"

    # compile pattern to global for speed, given how massive it'll (potentially) be
    pelimoji_prog = re.compile(pattern)
    # And the pattern to replace it with!
    pelimoji_replace = r'<i><img alt=":\g<emoji>:" src="/emoji/\g<emoji>.png" style="width:2em; height:2em"/></i>'
    #pelimoji_replace = r'<i class="cemoji cemoji-\g<emoji>" title=":\g<emoji>:"><span>:\g<emoji>:</span></i>'


def replace(content):
    fileext = str(content).split(".")[-1].lower()
    if fileext in ["md"]:
        try:
            content._content = pelimoji_prog.sub(pelimoji_replace, content._content)
        except TypeError:
            print(
                "Something went wrong editing {} for emojicustom, sorry".format(
                    str(content)
                )
            )


def register():
    pelican.signals.initialized.connect(init)
    pelican.signals.content_object_init.connect(replace)