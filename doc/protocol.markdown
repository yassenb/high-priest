# Overview

The backend and UI exchange JSON messages. Each message has a `type` which can be of the form `<name>` or
`<name>/<name>`. The other obligatory field is `data` which denotes the actual message data. An example message would be
```json
{
    "type": "chat",
    "data": {
        "text": "hello",
        "user": "pesho"
    }
}
```

# Messages

The messages are split into two main groups with subgroups for separate functionalities and each message type is in a
separate section with a corresponding title. For each type it's data fields are listed as bullets. An array is enclosed
in `[]`. Nested attributes are indented.

## From backend to UI

### Chat

#### `chat`

* `text` - the chat message contents
* `user` - the name of the message's sender

### Game setup phase

#### `setup/heroes`

* [`hero`] - a list of heroes available for picking
  * `id` - an ID to use, for example, when making the selection via `setup/pick_hero`
  * `name` - the hero's name

#### `setup/allies`

* [`ally`] - a list of allies that the player was given
  * `id` - an ID to use, for example, when making a swap via `setup/swap_ally`
  * `name` - the ally's name

#### `setup/spells`

* [`spell`] - a list of spells that the player was given
  * `id` - an ID to use, for example, when making a swap via `setup/swap_spell`
  * `name` - the spell's name

#### `setup/new_ally`

* `ally` - the same as `ally` in `setup/allies`

#### `setup/new_spell`

* `spell` - the same as `spell` in `setup/spells`

## From UI to backend

### Chat

#### `chat`

* `text` - the chat message contents

### Game setup phase

#### `setup/ready`

This is just an empty message used to signal to the backend that the user is ready to start the game

#### `setup/pick_hero`

* `id` - the ID of the hero that was picked

#### `setup/swap_ally`

* `id` - the ID of the ally that was swapped. This field can be left out indicating no ally was swapped

#### `setup/swap_spell`

* `id` - the ID of the spell that was swapped. This field can be left out indicating no spell was swapped

# Example dialogues

Below are example dialogue flows listed just by message types. Everything coming from the backend is denoted via `b:`
while everything from the UI via `u:`.

## Game setup phase

u: `setup/ready`
b: `setup/heroes`
u: `setup/pick_hero`
b: `setup/allies`
b: `setup/spells`
u: `setup/swap_ally`
u: `setup/swap_spell`
b: `setup/new_ally`
b: `setup/new_spell`
