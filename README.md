<details>
<summary><h3>Table of contents</h3></summary>

1. [TLDR](#tldr)
2. [Features](#features)
3. [Installation](#installation)
4. [Usage](#usage)
    1. [Basic manipulation](#basic-manipulation)
    2. [Search](#search)
    3. [Create surrounding](#create-surrounding)
    4. [Replace](#replace)
    5. [Undo/redo](#undoredo)
5. [Configuration](#configuration)
6. [Known issues](#known-issues)
7. [See also](#see-also)
8. [Final note](#final-note)

</details>

## TLDR

![](https://github.com/ElectricR/Encapsul8-assets/blob/master/assets/full.webp)

Encapsul8 is a surround-like plugin for [Kakoune](https://github.com/mawww/kakoune) with select-then-update paradigm.

`ms(` - surround with parentheses. `m"i` - select the content of double quotes. `m({` - replace parentheses with curly braces. Clippy will tell you the rest.

[Installation](#installation).

Godspeed!

## Features

* Select-then-update paradigm provides visual feedback and familiar flow
* Clippy hints help you learn as you go
* Enhanced undo/redo saves selections to restore them later
* Iterative search helps you modify nested surroundings
* Two-phase search identifies the nearest matching object

## Installation

[Plug.kak](https://github.com/andreyorst/plug.kak):
```
plug "ElectricR/Encapsul8" config %{
    require-module encapsul8-load-defaults
}
```

Optionally install [jq](https://github.com/jqlang/jq) - this will allow better undo/redo handling. Check [undo](#undoredo) section for more information.

## Usage

All examples assume the [default](https://github.com/ElectricR/Encapsul8/blob/master/rc/config.kak) configuration.

### Basic manipulation

The default entry point to Encapsul8 is the `m` key. From there one has two options - either [search](#search) for a pair or [apply](#create-surrounding) it to the current selection.

Once the pair is found, it will be highlighted with the selection regions and one of the following actions can be performed:

* Delete the surrounding (e.g., `m)d`)
* Select the content of its surrounding (e.g., `m)i`)
* Select the content with its surrounding (e.g., `m)a`)
* [Replace](#replace) the surrounding
* Surround the content itself (e.g., `m)x"`, shortcut for `m)ims"`)
* Surround the current pair (e.g., `m)s"`, shortcut for `m)ams"`)

There are also a couple of convenient aliases defined, e.g. `mpd` will delete a pair of surrounding parentheses. Aliases are translated to an opening character by default.

![](https://github.com/ElectricR/Encapsul8-assets/blob/master/assets/basics.webp)

### Search

Normally, the search operation tries to find the current surrounding. If no such surrounding is found, the search will try to find the nearest matching pair in the key-dependent direction:

* If the current search item is an opening character, the direction is forward.
* If the current search item is a closing character, the direction is backward.
* If the current search item is non-directional, the direction is forward.

![](https://github.com/ElectricR/Encapsul8-assets/blob/master/assets/search-two-phase.webp)

Another feature of Encapsul8 is iterative search. This allows you to manipulate any surrounding of the current stack.

![](https://github.com/ElectricR/Encapsul8-assets/blob/master/assets/search-iterative.webp)

### Create surrounding

Creating surrounding is pretty straightforward with `ms<key>`. Pair aliases and pair symmetry will be respected.

![](https://github.com/ElectricR/Encapsul8-assets/blob/master/assets/surround.webp)

Unlike all other operations, there is no search to perform. To get better semantics, one can add a configuration similar to this:

```
map global normal M ':encapsul8-surround<ret>' -docstring 'Encapsul8 create surrounding'
set-option global encapsul8_mapping_surround_shortcut ''
```

### Replace

There are two ways to perform a replace in Encapsul8 - the quick one (e.g., `m)}`) and the dedicated one (e.g., `m)r}`).

With the quick replace, after selecting a pair, any key that is not bound to an action will trigger a replace operation. Pair aliases and pair symmetry will be respected.

![](https://github.com/ElectricR/Encapsul8-assets/blob/master/assets/replace-quick.webp)

The dedicated replace mode is similar to the quick one, except that it doesn't respect pair aliases and has no any additional actions except cancellation. This can be useful, if you want want to replace with some mapped character, e.g., `a`. This mode is disabled by default.

### Undo/redo
Suppose, you want to add a pair of parentheses to the current word. You type something like `:exec bei(<esc>a)<esc>` to achieve that. Now you suddenly decide to undo this change. You type `u` and revert it, but now you have twice as many selections pointing only to the edges of your word.

![](https://github.com/ElectricR/Encapsul8-assets/blob/master/assets/undo-1.webp)

The undo/redo functionality is a current attempt to improve the UX in these cases. With it, Encapsul8 will try to restore selections to the place just before your modification.

![](https://github.com/ElectricR/Encapsul8-assets/blob/master/assets/undo-2.webp)

Currently, there are two implementations for undo/redo - simple and jq:
* The simple implementation stores only the description of the last Encapsul8 operation.
* The jq implementation tries to store every Encapsul8 operation it can. This method is selected as active based on [this](https://github.com/ElectricR/Encapsul8/blob/416b0c67d218e91800024bf7feca7594507e8de7/rc/undo/init.kak#L2) evaluation. The following [file](https://github.com/ElectricR/Encapsul8/blob/416b0c67d218e91800024bf7feca7594507e8de7/rc/undo/jq.kak#L3) represents the state of jq in the current session.

Encapsul8 provides four public functions to work with undo/redo:
* `encapsul8-undo` performs an undo if the current `history_id` is the result of an Encapsul8 operation. Fails otherwise.
* `encapsul8-redo` performs a redo if the next `history_id` is the result of an Encapsul8 operation. Fails otherwise.
* Two wrappers that perform undo/redo and restore selections when possible. These are mapped automatically if you load the default configuration.

## Configuration

All tweakable options can be found [here](https://github.com/ElectricR/Encapsul8/blob/master/rc/config.kak). These should be self-explanatory.

## Known issues
* Undo does not work with files that contain spaces
* Undo selection restoration may not work for surrounding in some cases ([Example](https://github.com/ElectricR/Encapsul8/blob/8d59351fb234ee8ecf846e586d5ba61d43acc175/tests/test.src#L671))


## See also
* [kakoune-surround](https://github.com/h-youhei/kakoune-surround) - Surround selection, Change/Delete surrounder
* [kakoune-mirror](https://github.com/Delapouite/kakoune-mirror) - Grow / shrink selections in both directions or surround them

## Final note

If you would like to report an issue or provide feedback, please don't hesitate to tell me about it here or contact me directly.
