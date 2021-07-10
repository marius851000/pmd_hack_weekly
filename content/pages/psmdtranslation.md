# how to translation PSMD in another language with another alphabet ?

*note: The translation is a bit different with the EU rom and the US rom. My tools only work fully on US rom, and I might have mixed a bit both accidentaly.* TODO:

## 1. How does 3ds patching work

3ds roms (in the .3ds format) store the game data's (not including game code and some metadata) as a file system (think of it like an zip archive file).

This guide assume you have an decrypted 3ds file. A decrypted 3ds file can be generated using the godmode9 bootloader on a 3ds with a custom firmware.

On how to add a CFW to a 3ds, I recommend the site [3ds.hacks.guide](https://3ds.hacks.guide/). This guide also include the installation of godmode9.

I will explain how to patch a game by using either a recent citra emulator version, or luma.

## 2. Extract the 3ds game

We only need to extract the game data, as we don't need to patch compiled game code.

``ctrtool.exe <3ds rom file> --romfsdir <directory that will contain the data>``

TODO: more detailed instruction

## 3. Explanation of the language files

### fonts
the fonts are stored in the ``font`` sub-folder. They work by pair, with a ``.img`` file containing the appearance of the characters, and a ``.dic`` containing others data.

### message
At the root of the game, there are some ``message_<language>.bin`` and/or ``message.bin`` (depending on the region of your rom). There are also adjacent ``.lst`` files. They are unused by the game, but contain some interesing metadata.

## 4. tools

There are two different tools, one for editing texts, and another one for editing fonts. They are both command line interface, written using the rust programming language.

### translatepmd

This tool convert a ``message.bin``/``message_<language>.bin`` file and the adjacent ``.lst`` file to a gettext file, that can be edited with many translation software (I personally use poedit). It also transform a gettext translation to a message ``.bin`` file.

To generate the gettext file from the US rom, run:

``translatepmd.exe farc to-pot <source message .bin file> <resulting po file>``

TODO: find which message.bin is used in US rom (I think I remember it's ``message_us.bin``)

You can then open this file with a compatible translation editor (``poedit`` work well for this).


A bit of note about how this po work:

TODO: maybe that's not the best method. See notes/other

Each entry is in the form of ``<code> <text>``. You shouldn't copy the code and the first space following it. The game use an id to identify the text, rather than the english/japanese text.

To recreate the ``.bin`` file, you can run the command

``translatepmd.exe farc from-po <source po file> <target .bin file>``

### pmdfonttool

This tool convert a ``.img`` and ``.dic`` font file to a folder containing a picture for each character. It can also import ``ttf`` fonts. I don't know how to create ttf fonts, but it certainly does have some good editor I haven't searched.

To extract a font from the game :

``pmdfonttool.exe generate <.dic file> <.img file> <target folder>``

The resulting folder is in the format : <id>_<x alignment>_<y alignment>_<distance to the next character>_<unk1>_<unk2>.png

- id is the UTF-8 codepoint
- alignments are how the character is moved from where it originally stand on.
- distance is the distance between the beggining of the character and the next character
- unk1 and unk2 mean something I don't know. They are usually 0, and you should probably stick with this value (maybe they are just padding)

Additionally, each of those number are stored as 16 bits integer, so they can't be over or equal to 2^16


# Notes/Other stuff to fix
Is having a per id the best ? Wont the standard *per-string* translation work better ?
``paradise_dummy_all.bin`` might be unused... (I think that paradise is codename for Gates)