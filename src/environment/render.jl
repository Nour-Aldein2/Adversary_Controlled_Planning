function is_visible(room::Room, sensor::Sensor, cell::CartesianIndex{2})
    f    = DIRECTIONS[sensor.direction]
    beam = [sensor.position + k * f for k in 1:sensor.range]     # every cell on the line
    return cell in beam
end

"""Print the room as text: '#' wall, `.` free, ⬚ watched, `s` start, 🏁 goal, 👁 sensor."""
function print_room(room::Room, sensors::Vector{Sensor})
    # Step 1: turn each Bool into a Char
    grid = map(w -> w ? '#' : '.', room.walls)

    # Step 1b: mark free cells seen by any sensor
    for cell in CartesianIndices(grid)
        if grid[cell] == '.' && any(s -> is_visible(room, s, cell), sensors)
            grid[cell] = '⬚'
        end
    end

    # Step 2: mark special cells (a CartesianIndex works directly as an index)
    grid[room.start] = 's'
    for g in room.goals
        grid[g] = '🏁'
    end
    for s in sensors
        grid[s.position] = '👁'
    end

    # Step 3: print one row per line
    for r in eachrow(grid)
        println(join(r, ' '))
    end
end

# ---- Demo: runs only with `julia --project=. src/environment.jl 10 10` ----
function demo(args)
    rng = Xoshiro(12)

    # Map size from the command line, default 8x8
    height  = isempty(args)    ? 8 : parse(Int, args[1])
    width   = length(args) < 2 ? 8 : parse(Int, args[2])

    walls   = fill(false, height, width)
    walls[2:end-1, 3] .= true       # One vertical wall
    walls[6:7, 5:6] .= true         # 2×2 island

    room    = Room(walls, CartesianIndex(1, 1), [CartesianIndex(height, width)])
    sensors = random_sensors(rng, room, 3, 4)

    println("\nRoom size: ", size(room.walls), ", walls: ", count(room.walls))
    for s in sensors
        println("\tSensor at ", Tuple(s.position), " facing ", DIRECTIONS[s.direction].I, " with range ", s.range)
    end
    print_room(room, sensors)
    return 0
end

if abspath(PROGRAM_FILE) == @__FILE__
    demo(ARGS)
end