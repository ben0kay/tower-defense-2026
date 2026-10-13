# Godot 2D Space Tower Defense — Navigation & Performance Notes

> Design reference for the **new Godot 2D project**. Distilled from the older GameMaker tower-defense implementation and discussions about large ship swarms. This is a **plan, not implemented code**.

## Core gameplay requirements

- Fully **2D, top-down space tower defense**, inspired chiefly by *Helix Defense 2* gameplay and mechanics.
- Towers are placed **only on designated valid grid squares**. Tower footprints can block enemy travel; placement must not seal required routes.
- Alien ships spawn from **portals or permitted map edges**, controlled by the wave configuration. Support multiple spawn points and multiple destinations.
- Ships navigate around asteroids, walls, structures, and new towers; they move/turn smoothly and should not look locked to grid centers.
- Towers automatically acquire targets; support target modes such as **first, last, closest, furthest, strongest, weakest**, and specialized priorities later.
- Towers can upgrade. Separate the **tower base** and **rotating turret**, with **Marker2D muzzle points** for shots/flash effects. Begin with primitive/simplified artwork and refine after gameplay works.

## Useful lessons confirmed in the old GameMaker code

| Old mechanism | What to carry forward |
| --- | --- |
| `mp_grid` with blocked cells | Use one authoritative grid for walkability and tower footprints. |
| Per-enemy randomized path timers | **Stagger** requests so large waves do not repath on one frame. |
| Path cooldowns / `needs_repath` | Repath on meaningful changes, not every frame. |
| Offscreen/fog-of-war `lazy_factor = 5` | Reduce nonessential checks for unseen ships, **not** correctness-critical obstacle handling. |
| Randomized `path_shift` | Add small, safe route variation so swarms do not form one identical line. |
| Cached static cost grid | Cache map data, but **update/invalidate it when towers or obstacles change**. |
| Experimental weighted A* and flow field | Keep both as reference strategies; avoid carrying both complex systems into the initial build. |
| Tower target-acquisition cooldown (~5 frames) | Stagger targeting; retain targets until invalid rather than searching constantly. |
| Periodic visibility checks (6–12 frames) | Spread noncritical checks across frames. |
| Camera culling and controlled particles | Limit rendering/VFX work, particularly thrusters, muzzle flashes and deaths. |

**Pitfalls to avoid from legacy experiments:** a failed path should **not** send an enemy straight through solid obstacles; a cached grid must not become stale; random staggering alone cannot cap worst-case pathfinding spikes; route-shift offsets must not cross blocked cells. The old placement checks occupancy/buildable tiles but do not clearly guarantee that all required spawn-to-goal routes remain available.

## Recommended first navigation approach (simple and measurable)

Start with **Godot `AStarGrid2D` + a central path-request manager**. Do **not** automatically calculate individual A* routes for every enemy every frame.

1. **Navigation grid:** walkability, obstacle occupancy, valid build cells, tower footprints, portals, edge entries, goals; store cell state in compact arrays.
2. **Request queue:** ships request a route on spawning, when their route becomes invalid, or when a meaningful target/route change occurs. Spread requests over frames with a configurable **per-frame budget**. Prioritize ships approaching a blocked segment.
3. **Version/invalidation:** increment a grid revision after placement/removal/destruction. Invalidate affected routes and **never allow a ship to travel through a newly blocked tile while awaiting repath**.
4. **Path reuse:** cache routes where start/goal/corridor allow it. Do not assume every ship can reuse a path from an unrelated location.
5. **Movement:** follow waypoints with smooth facing/turning. If adding offsets or separation, keep clearance from obstacles; do not use full rigid-body physics for each ship.
6. **If no route exists:** wait, retreat, or later attack obstacles (if that mechanic is enabled); never fall back to direct travel through blockers.
7. **Placement validation:** check buildable cells, occupancy, resources, and ensure **all required portal/edge-entry → designated goal** connections remain reachable *before* committing the tower. Define how to handle spawns temporarily disabled by wave settings.

**Potential upgrade:** Benchmark a **reverse distance field / flow field**, especially when many ships share goals. Build a field once per goal (or a multi-goal field if goal choice is flexible), recalculating on relevant map changes. Following it is cheap; full field rebuilds can be expensive on large grids. Compare measured costs against budgeted/cached A* rather than guessing.

## Other swarm-performance practices

- Keep enemy **simulation state** separate from visuals; use lightweight `Node2D` initially, with more centralized data/drawing only if profiling justifies it.
- Perform expensive targeting and AI decisions at **staggered intervals**; move/render smoothly every frame.
- Use a simple **spatial bucket/grid** for nearby-enemy queries if broad tower scans become expensive.
- Avoid unnecessary `PhysicsBody2D` simulation and pairwise enemy collision checks; slight overlap or cheap local separation is acceptable for flying ships.
- Pool/reuse projectiles and effect instances **if profiling reveals allocations as an issue**; avoid premature systems.
- Cap particle emission and cull off-camera visuals without freezing gameplay-critical navigation.
- Add a debug overlay: blocked/buildable cells, routes or arrows, grid revision, queued/completed paths, nav time, active enemies, FPS/frame time.

## Practical development sequence

1. **Navigation test:** one arena, portal/edge spawning, one destination, asteroids, dynamic tower-placement blockers; test 100–200 simple ships.
2. **Complete gameplay loop:** turrets/Marker2D muzzles, targeting, projectiles, damage, wave settings, credits, upgrades, victory/defeat.
3. **Scale and profile:** aim to **benchmark ~500 simultaneously moving ships at 60 FPS** on the development PC (a target, not a guarantee). Compare A* queue/caching against shared flow fields if pathfinding actually limits performance.
4. **Polish:** particles, thrusters, lasers, explosions, varied enemies, visual route variation, additional maps and research.

## Coding and scope conventions

Read `notes/CODING_PREFERENCES/CODING_PREFERENCES.txt` before implementation. Relevant principles: **performance-conscious, compact/readable code; grouped data; centralized tweakable global parameters; enums where useful; full coherent functions rather than scattered snippets; sensible culling; avoid unnecessary abstraction and defensive checks; commented future extension points**. The old file is GameMaker/GML-specific, so adapt conventions sensibly to **GDScript/Godot** rather than copying GML syntax or built-in variable names.

**Keep this a compact, finishable game.** Preserve the old design lessons, not its full accumulated GameMaker architecture.
