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

### Prepare room for the agents ###
function create_random_room(rng::AbstractRNG, h::Int, w::Int,
                            start::CartesianIndex{2}, goals::Vector{CartesianIndex{2}})
    walls = fill(false, h, w)

    n_walls = rand(rng, 1:3)                  # random number of walls: 1, 2 or 3
    for _ in 1:n_walls
        col = rand(rng, 2:w-1)                # which column the wall is in
        top = rand(rng, 1:h-1)                # which row the wall starts at
        walls[top:end-1, col] .= true         # wall goes down to the second-last row
    end

    walls[start] = false                      # never block the start
    for g in goals
        walls[g] = false                      # never block a goal
    end
    return Room(walls, start, goals)
end