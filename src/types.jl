# The map: fixed for the whole game, so immutable
struct Room
    walls::Matrix{Bool}               # true = obstacle; size(walls) gives rows, cols
    start::CartesianIndex{2}
    goals::Vector{CartesianIndex{2}}
end

# Create a mutable struct for Player 1 (i.e. the robot). It should have memory of the current state
mutable struct Robot
    state::CartesianIndex{2}   # current location
    past_state::CartesianIndex{2}

    next_action::Int64
    past_action::Int64

    reward::Float64
end

# Create a mutable struct for Player 2 (i.e. the adversary). It should have memory of where the sensors placed and 
#   where is the adversary looking at a time step.
struct Sensor
    """The position and direction the sensors are facing does not change"""
    position::CartesianIndex{2}
    direction::Int64   # Possible directions it's facing (there are 1-8) 
    range::Int64   # How far can the sensor detect
end


mutable struct Environment
    map::Room
    robot::Robot
    adversary::Vector{Sensor}
end

struct Adversary
    sensors::Vector{Sensor}             # sensors[j] is pure strategy j
    m::Vector{Float64}                  # movement cost for every (s, a), the same for every column
    O::SparseMatrixCSC{Float64, Int}    # observation cost: column j belongs to sensors[j]
    # the reason why m is a Vector whereas O is a matrix is that each column in O corresponds to a sensor, since each sensor will have its unique observation cost vector, whereas the moving cost is the same for all sensors since they are environment related (rather than being related to the adversary)
end