function polar_to_rectangular(rs, θs)
    possible_actions = CartesianIndex{2}[]

    for r in rs
        for θ in θs
            x, y = r*cos(θ), r*sin(θ)
            xi, yi = round(Int, x), round(Int, y)

            d = hypot(xi, yi)

            if isapprox(d, r, atol=1e-10)
                action = CartesianIndex(-yi, xi)   # (x, y) → (row, col): up is −row

                if action ∉ possible_actions
                    push!(possible_actions, action)
                    @printf("New action (r, θ) → (x, y): (%.3f, %.3f) → (%.0f, %.0f)\n", r, θ, x, y)
                end
            end
        end
    end
    return possible_actions
end



###### Env Functions ######

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
    state_index(room, cell) -> Int

Convert a grid `cell` into its state number (column-major order).
"""
function state_index(room::Room, cell::CartesianIndex{2})
    indices = LinearIndices(room.walls)
    return indices[cell]
end

"""
    state_index(room, r, c) -> Int

Same as `state_index(room, CartesianIndex(r, c))`.
"""
state_index(room::Room, r::Int, c::Int) = state_index(room, CartesianIndex(r, c))


"""
    cell_of(room, idx) -> CartesianIndex{2}

Convert a state number `idx` back into its grid cell. Inverse of `state_index`.
"""
function cell_of(room::Room, idx::Int)
    cell = CartesianIndices(room.walls)[idx]
    return cell
end


function is_valid_move(room::Room, cell::CartesianIndex{2}, action::CartesianIndex{2})
    s′ = cell + action
    inside = checkbounds(Bool, room.walls, s′)   # destination is on the map
    return inside && !room.walls[s′]             # ...and not a wall (checked only if inside)
end

function move_cost(action::CartesianIndex{2})
    x, y = Tuple(action)
    r = hypot(x, y)
    return r
end

function getting_observed_cost(sensor::Sensor, cell::CartesianIndex{2})
    covered_cells = [sensor.position + r * DIRECTIONS[sensor.direction] for r in 1:sensor.range]
    idx = findfirst(==(cell), covered_cells)     # step along the beam, or nothing
    idx === nothing && return 0.0                # not watched → no extra cost
    costs = range(OBS_COST_NEAR, OBS_COST_FAR; length=sensor.range)
    return costs[idx]
end