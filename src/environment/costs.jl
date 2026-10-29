function move_cost(action::CartesianIndex{2})
    x, y = Tuple(action)
    r = hypot(x, y)
    return r
end

"""
    sa_index(room, s, a) -> Int

Position of the state-action pair (state number `s`, action number `a`)
in a cost vector `c` or frequency vector `f`.
"""
function sa_index(room::Room, s::Int, a::Int)
    return (s - 1) * length(ACTIONS) + a
end
sa_index(room::Room, cell::CartesianIndex{2}, action::CartesianIndex{2}) =
    sa_index(room, state_index(room, cell), findfirst(==(action), ACTIONS))


""" Adds the time step cost to the length of the path (as penalty)"""
function get_move_cost_vector(room::Room)
    cost_vector = zeros(length(room.walls) * length(ACTIONS))   # one entry per (s, a)
    for s in 1:length(room.walls)
        for a in 1:length(ACTIONS)
            i = sa_index(room, s, a)
            cost_vector[i] = TIME_STEP_COST + move_cost(ACTIONS[a])
        end
    end
    return cost_vector
end


function cost_vector(room::Room, sensor::Sensor)
    cost_vector = spzeros(length(room.walls) * length(ACTIONS))
    for s in 1:length(room.walls)
        for a in 1:length(ACTIONS)
            if !is_valid_move(room, cell_of(room, s), ACTIONS[a])
                println("Agent performed invalid move.")
                continue
            end
            s′ = cell_of(room, s) + ACTIONS[a]      # the cell the robot moves into
            i = sa_index(room, s, a)
            cost_vector[i] = getting_observed_cost(sensor, s′)
        end
    end
    return cost_vector
end


