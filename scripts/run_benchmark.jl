using Random
using DoubleOracle_PathPlanning

function (@main)(args)
    rng = Xoshiro(42)

    # Map size from the command line, default 5x5
    height  = isempty(args)   ? 5 : parse(Int, args[1])
    width   = length(args) < 2 ? 5 : parse(Int, args[2])

    walls   = fill(false, height, width)
    walls[2:end-1, 3] .= true       # One vertical wall

    room    = Room(walls, CartesianIndex(1, 1), [CartesianIndex(height, width)])
    sensors = random_sensors(rng, room, 3, 4)

    println("Room size: ", size(room.walls), ", walls: ", count(room.walls))
    for s in sensors
        println("Sensor at ", Tuple(s.position), " facing ", s.direction)
    end

    return 0
end

