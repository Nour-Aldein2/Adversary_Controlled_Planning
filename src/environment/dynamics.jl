function get_info(env::Environment)
    walls = env.map.walls
    valid(c) = checkbounds(Bool, walls, c) && !walls[c]   # in bounds and not a wall

    return (
        robot_loc     = env.robot.state,                    # robot's current cell (row, col)
        sensors       = env.adversary,                      # all sensors: position, direction, range
        goal_loc      = env.map.goals,                      # list of goal cells
        reward_so_far = env.robot.reward,                   # reward collected so far
        map_size      = size(walls),                        # (rows, cols) of the map
        n_states      = length(walls),                      # |S|: every cell, walls included
        n_free        = count(!, walls),                    # cells the robot can stand on
        n_actions     = length(ACTIONS),                    # |A|: should be 16
        n_sensors     = length(env.adversary),              # k: number of cost vectors (columns of C)
        sa_length     = length(walls) * length(ACTIONS),    # |S|·|A|: length of every cost vector
        start_ok      = valid(env.map.start),               # true if start is inside the map and free
        goals_ok      = all(valid, env.map.goals),          # true if every goal is inside the map and free
        watched       = [count(c -> is_visible(env.map, s, c), CartesianIndices(walls))
                         for s in env.adversary],           # cells seen by each sensor (0 = useless sensor)
    )
end

function reset_env(env::Environment)
    ## TODO: compelete the resetting function. I think you will need to update the Environment struct such that it places the adversary
    return env
end