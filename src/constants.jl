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



const MAP_HEIGHT    = 100
const MAP_WIDTH     = 100
const DIRECTIONS    = CartesianIndex{2}[  # CartesianIndex{row, col}
    CartesianIndex(-1, 0),  # up
    CartesianIndex(1, 0),   # down
    CartesianIndex(0, -1),  # left
    CartesianIndex(0, 1),   # right
    CartesianIndex(-1, 1),  # up-right
    CartesianIndex(1, 1),   # down-right
    CartesianIndex(1, -1),  # down-left
    CartesianIndex(-1, -1), # up-left
]
const MAX_N_SENSORS = 8
const RANGE         = 8   # Sensor's coverage (it could be randomise for different sensors, but for now its a const)
const CONE_Θ        = π / 4 # 90° cone = 45° either side (our choice; the paper doesn't say)

const R             = (sqrt(r) for r in (1, 2, 5))
const Θ             = ((2π/16)*j for j in 0:15)   # 16 possible directions
const ACTIONS       = polar_to_rectangular(R, Θ)
const OBS_COST_NEAR = 20.0   # Paper, Sec. 5: "cost of 20 ... if observed by an adjacent sensor"
const OBS_COST_FAR  = 10.0   # Paper, Sec. 5: "cost 10 ... if the sensor is at the maximum distance"
const TIME_STEP_COST     = 0.0 

println("There are ", length(ACTIONS), " actions: ", Tuple.(ACTIONS))