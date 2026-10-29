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


"""
    is_valid_move(room, cell, action) -> Bool

`true` if the robot can move from `cell` by `action`.
"""
function is_valid_move(room::Room, cell::CartesianIndex{2}, action::CartesianIndex{2})
    s′ = cell + action
    inside = checkbounds(Bool, room.walls, s′)   # destination is on the map
    return inside && !room.walls[s′] &&          # ...and not a wall (checked only if inside)
           line_of_sight(room, cell, s′)         # ...and the move doesn't cross a wall
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
