# AGENTS.md

## Project
- Godot project, not a package-manager repo; there are no discovered test, lint, formatter, CI, or task-runner configs.
- `project.godot` targets Godot `4.6` with Forward Plus and runs `res://main.tscn`.
- Prefer the Godot editor for scene/resource/project edits when possible; if editing `.tscn`/`.tres` manually, keep `uid://` and `ExtResource` references stable.

## Commands
- Run the game with a Godot 4.6 binary from the repo root: `godot --path .`.
- Export uses preset `Windows Desktop` from `export_presets.cfg`; it writes `./Ord.exe`, embeds the PCK, and enables the console wrapper.
- `.gitignore` ignores `.godot/`, `.vscode/`, and `*.exe`; do not treat exported executables or the Godot import cache as source changes.

## Runtime Wiring
- `main.tscn` instantiates the `base` `TileMapLayer`, `Characters/Mo/Mo.tscn`, and `Common/AStarGrid/a_star_grid.tscn`.
- `base` uses `Common/nav_tile_map.gd`; its `entered_map`, `entered_tile`, and `exit_map` signals are connected to `Mo` in `main.tscn`.
- `Mo.tscn` is a `CharacterBody2D` using `Characters/Mo/Scripts/mo_controller.gd`; `MoController` builds its `StateMachine` in `_ready()` from `get_states()`.
- New character states must have a `class_name`, implement `static get_state_name()`, return a value from `constants/states.gd`, and be added to `MoController.get_states()` or `StateFactory` cannot resolve them.

## Navigation And Tiles
- `Common/AStarGrid/a_star.gd` builds an `AStarGrid2D` from the exported `tile_map` and marks tiles solid when custom data `type == "obst"`.
- Tile custom data values are centralized in `constants/tilemap.gd`: `path`, `obst`, and `climb`; preserve the `type` custom data layer in `Environment/Fields/fields_tile_set.tres`.
- `MoveState` emits `new_path_cell` when the current tile has `type == "climb"`; movement state changes depend on tile metadata, not collision alone.

## Assets
- Aseprite `.import` files reference source `.aseprite` paths that are not present in the repo; available source assets are the checked-in PNGs plus Mo sprite JSON frame data.
