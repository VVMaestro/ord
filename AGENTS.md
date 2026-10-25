# AGENTS.md

## Project
- Godot project, not a package-manager repo; there are no discovered test, lint, formatter, CI, or task-runner configs (`res://tests/` does not exist).
- `project.godot` targets Godot `4.7` (`config/features`) with Forward Plus and runs `res://main.tscn`; default canvas texture filter is Nearest (pixel art).
- Prefer the Godot editor for scene/resource/project edits when possible; if editing `.tscn`/`.tres` manually, keep `uid://`, `unique_id`, and `ExtResource` references stable.
- `.gitattributes` normalizes text files to LF.

## Godot AI MCP
- `addons/godot_ai/` is the Godot AI editor plugin (MCP server, `godot-ai` tools); it is enabled in `[editor_plugins]` and registers the `_mcp_game_helper` autoload in `project.godot`.
- With the editor open, prefer the `godot-ai` MCP tools for scene/node/script edits, running the game, and reading editor/game logs; `script_create`/`script_patch` return GDScript diagnostics.
- Do not edit files under `addons/godot_ai/` unless the task is about the plugin itself.

## Commands
- Run the game with a Godot 4.7 binary from the repo root: `godot --path .`.
- Export uses preset `Windows Desktop` from `export_presets.cfg`; it writes `./Ord.exe`, embeds the PCK, and enables the console wrapper (`Ord.console.exe`).
- `.gitignore` ignores `.godot/`, `.vscode/`, `.idea/`, and `*.exe`; do not treat exported executables or the Godot import cache as source changes.

## Runtime Wiring
- `main.tscn` instantiates the `base` `TileMapLayer`, `Characters/Mo/Mo.tscn`, `Common/AStarGrid/a_star_grid.tscn` (`AStarGrid`), and a `Camera2D`.
- Node references are exported properties wired in `main.tscn`: `base.a_star_grid`/`base.core_entity`, `Mo.a_star_grid`/`Mo.tile_map`, `AStarGrid.tile_map`.
- `base` uses `Common/nav_tile_map.gd` (`NavTileMap`); it routes `_input` through `Common/input_event_processor.gd` (strategies keyed by `InputEvent` class name), draws the preview path `Line2D` while `Mo` is `IDLE`, and emits `entered_map`, `entered_tile`, `exit_map`, `clicked_tile`.
- `main.tscn` still connects `entered_map`/`entered_tile`/`exit_map` to `Mo._on_mouse_*` methods that no longer exist in `MoController`; fix or remove these connections when touching that wiring.
- Click-to-move currently lives in `IdleState.handle_input` (`mouse_click` action -> `AStar.calculate_in_global` -> `RUN`); `StateCoreEntity.load_states()` (tile-driven state queue) is work in progress and not called yet.

## State Machine
- Core classes are in `Common/StateMachine/`: `StateCoreEntity` (`CharacterBody2D` base for characters), `StateMachine`, `StateFactory`, `StateQueue`, `State`.
- `Mo.tscn` uses `Characters/Mo/Scripts/mo_controller.gd`; `MoController extends StateCoreEntity`, and `StateCoreEntity._ready()` builds the `StateMachine` and `StateFactory` from `get_states()`. `StateCoreEntity` expects `AnimationPlayer` and `Sprite2D` children.
- New states extend `State` (or `MoveState` in `Characters/Mo/Scripts/States/SuperStates/`), need a `class_name`, a `_init(state_machine)`-compatible constructor, both `get_state_name()` and `static get_static_state_name()` returning a `StatesConstants.State` value from `constants/states_constants.gd`, and must be added to `MoController.get_states()`, or `StateFactory` cannot resolve them.
- `StateMachine.change_state()` frees the old state node and instantiates a new one each time; states reach the character via `sm.state_core_entity` / `core_entity()`.
- Animation names are mapped in `StatesConstants.ANIM`; `CLIMB` currently reuses the `hit` animation.

## Navigation And Tiles
- `Common/AStarGrid/a_star.gd` (`AStar`) builds an `AStarGrid2D` from the exported `tile_map` and marks cells solid when their tile type is `TilemapConstants.TileType.OBST`.
- Tile types are an int enum in `constants/tilemap_constants.gd` (`OBST = 0`, `PATH = 1`, `CLIMB = 2`), read from custom data key `TILE_TYPE_KEY = "type"`; the `type` layer in `Environment/Fields/fields_tile_set.tres` is an int layer, so keep enum order and tileset values in sync.
- `MoveState` emits `new_path_cell` when the current tile type is `CLIMB` (nothing listens to it yet); movement state changes depend on tile metadata, not collision alone.
- `Environment/Forest/` and `Environment/Tiled/` (Tiled `.tmx`/`.tsx` sources) are not used by `main.tscn`.

## Assets
- Aseprite `.import` files reference source `.aseprite` paths that are not present in the repo; available source assets are the checked-in PNGs plus Mo sprite JSON frame data.
- `docs/a_star_improvements.md` holds notes on path smoothing ideas.
