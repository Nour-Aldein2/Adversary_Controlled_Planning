# Create function to place the senosrs/cameras
"""
    random_sensors(rng, room, n, range) -> Vector{Sensor}

Place `n` sensors on distinct random free cells of `room`, each facing a
random direction from `DIRECTIONS`.

Each sensor is one pure strategy of the adversary (one column of the game matrix).

# Arguments
- `rng::AbstractRNG`: random number generator, e.g. `Xoshiro(42)`, for reproducibility.
- `room::Room`: the map; sensors are never placed on walls.
- `n::Int`: number of sensors to place.
- `range::Int`: maximum detection distance of every sensor.

# Throws
- `BoundsError` if `n` exceeds the number of free cells.

# Examples
```julia
rng     = Xoshiro(42)
sensors = random_sensors(rng, room, 8, 10)
```
"""
function random_sensors(rng::AbstractRNG, room::Room, n::Int, range::Int)
    free_cells = findall(!, room.walls)          # every non-wall cell
    positions  = shuffle(rng, free_cells)[1:n]   # n distinct random cells
    return [Sensor(p, rand(rng, 1:MAX_N_SENSORS), range) for p in positions]
end

"""
    line_of_sight(room, from, to) -> Bool

`true` if no wall lies on the straight line between `from` and `to`.
"""
function line_of_sight(room::Room, from::CartesianIndex{2}, to::CartesianIndex{2})
    d = Tuple(to - from)
    n = ceil(Int, 2 * hypot(d...))             # enough steps not to skip a cell
    for k in 1:n-1
        p    = round.(Int, (k / n) .* d)       # point k/n of the way, rounded to a cell
        cell = from + CartesianIndex(p...)
        room.walls[cell] && return false       # a wall blocks the view
    end
    return true
end


function is_visible(room::Room, sensor::Sensor, cell::CartesianIndex{2})
    d = cell - sensor.position
    d == CartesianIndex(0, 0) && return false                   # 1. not the sensor's own cell

    v    = collect(Tuple(d))
    dist = norm(v)
    dist > sensor.range && return false                         # 2. close enough

    f = collect(Tuple(DIRECTIONS[sensor.direction]))
    cosθ = dot(v, f) / (dist * norm(f))
    cosθ < cos(CONE_Θ) - 1e-9 && return false                   # 3. inside the cone

    return line_of_sight(room, sensor.position, cell)           # 4. no wall in the way
end

function getting_observed_cost(room::Room, sensor::Sensor, cell::CartesianIndex{2})
    is_visible(room, sensor, cell) || return 0.0              # not watched → no extra cost
    sensor.range == 1 && return OBS_COST_NEAR                 # avoid dividing by zero
    dist = hypot(Tuple(cell - sensor.position)...)
    t    = (dist - 1) / (sensor.range - 1)                    # 0 when adjacent, 1 at max range
    return OBS_COST_NEAR - t * (OBS_COST_NEAR - OBS_COST_FAR)
end
