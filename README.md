# Card-Game

A small pixel-art casino adventure where you explore a top-down casino and play card games for in-game money.

## Play in your browser

**[Play Card-Game](https://sharmnten.github.io/card-game/)**

The browser build is also included in [`docs/`](docs/). No installation is required for the web version.

## Quick start

1. Open the [browser demo](https://sharmnten.github.io/card-game/).
2. Use `WASD` to move around the casino.
3. Press `E` when an interaction prompt appears to enter a table or leave the casino.

The game starts with `$1000` in-game money. It does not use real money or connect to a payment service.

## Features

- Explore a top-down pixel-art casino as a customizable character.
- Walk up to tables and start a game with an interaction prompt.
- Play poker with a shuffled 52-card deck, community cards, betting, checking, raising, and folding.
- Play Ride the Bus through a sequence of red/black, higher/lower, and suit guesses.
- Carry your in-game money and player position between the casino and card-game scenes.
- Run the same project as a native Godot game or as a browser export.

## Run locally

### Requirements

- [Godot 4.7](https://godotengine.org/download/archive/)

### Launch the project

1. Clone the repository:

	```sh
	git clone https://github.com/sharmnten/card-game.git
	cd card-game
	```

2. Open the folder in Godot 4.7.
3. Press **Play Project**. The main scene is configured in `project.godot`.

To rebuild the browser version, use Godot's **Project > Export** menu and select the existing `Web` preset. The export target is `docs/index.html`.

## Controls

| Action | Keyboard |
| --- | --- |
| Move | `W` `A` `S` `D` |
| Interact | `E` |

Table actions are selected through the on-screen controls after entering a game.

## How it works

The project is built in Godot using `.tscn` scenes and GDScript. The casino is a top-down scene with collision areas around each table; entering an area reveals the relevant interaction prompt. Poker and Ride the Bus each maintain their own shuffled deck and render cards from the shared card scene.

`GameState` is an autoload singleton. It owns the player's money, character customization choices, and saved positions, allowing the player to move between the casino and card-game scenes without losing state.

## Project layout

- [`Scenes/`](Scenes/) contains the Godot scenes for the casino, player, UI, cards, and game tables.
- [`Scripts/`](Scripts/) contains movement, scene transitions, card-game logic, and shared state.
- [`Sprites/`](Sprites/) contains the casino, character, card, and UI art.
- [`Fonts/`](Fonts/) contains the project's Pixelify Sans font.
- [`docs/`](docs/) contains the generated web export.

## Credits and acknowledgements

- Built with [Godot](https://godotengine.org/).
- Uses the [Pixelify Sans](https://fonts.google.com/specimen/Pixelify+Sans) font.
- The repository includes the card, casino, character, and UI assets used by the game.
- The [`godot-super-wakatime`](addons/godot_super-wakatime/) editor plugin is included for development-time tracking.

This is a work in progress. Audio and additional polish are not yet included.
