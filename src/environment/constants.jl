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
const R             = (sqrt(r) for r in (1, 2, 5))
const Θ             = ((2π/16)*j for j in 0:15)   # 16 possible directions
const ACTIONS       = polar_to_rectangular(R, Θ)
const OBS_COST_NEAR = 20.0   # Paper, Sec. 5: "cost of 20 ... if observed by an adjacent sensor"
const OBS_COST_FAR  = 10.0   # Paper, Sec. 5: "cost 10 ... if the sensor is at the maximum distance"

println("There are ", length(ACTIONS), " actions: ", Tuple.(ACTIONS))