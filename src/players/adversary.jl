# Paper, Sec. 4: "the pure strategies for the opponent are the elements of K"
# One sensor = one cost vector cⱼ = m + oⱼ

# TODO 2: Adversary(room, sensors)  -> builds m and O
function Adversary(room::Room, sensors::Vector{Sensor})
    """In Julia, a constructor is just a function with the type’s name."""
    m = get_move_cost_vector(room)
    vs = SparseVector{Float64, Int}[]     # empty list of sparse vectors
    for s in sensors
        o = cost_vector(room, s)
        push!(vs, o)
    end
    O = hcat(vs...)                       # glue side by side: column j = sensor j
    return Adversary(sensors, m, O)
end

# TODO 3: column(adv, j)            -> cⱼ

"""
    pure_cost(adv, j) -> Vector{Float64}

Full cost vector of sensor `j`: cⱼ = m + oⱼ (column `j` of the paper's C).
In other words, this is the pure strategy for the adversary.
"""
function pure_cost(adv::Adversary, j::Int)
    cj = adv.m + adv.O[:, j]
    return cj
end

# TODO 4: mixed_cost(adv, q)        -> Cq   (Sec. 4.1: "c = Cqᵢ")

"""
    mixed_cost(adv, q) -> Vector{Float64}

Expected cost vector Cq = m + Oq when the adversary mixes over its sensors
with probabilities `q` (its mixed strategy). Paper, Sec. 4.1: "c = Cqᵢ".
"""
function mixed_cost(adv::Adversary, q::Vector{Float64})
    @assert sum(q) ≈ 1

    Cq = adv.m + adv.O * q
    return Cq
end

# TODO 5: best_response(adv, f̄)     -> (j, v)   (Sec. 4.2: "C(p) = c")   
"""
    best_response(adv, f̄) -> (j, v)

Column oracle C(p) (paper, Sec. 4.2): the sensor that costs the robot most.

# Arguments
- `adv::Adversary`: the adversary's sensors and cost vectors.
- `f̄`: the robot's average path, f̄ = Σᵢ pᵢ fᵢ. Each fᵢ is one path as a
  frequency vector (1 at every (s, a) it uses, 0 elsewhere), and pᵢ is its
  probability. Entry (s, a) of f̄ is the probability of taking a in s.
  For a single path, f̄ is just that path.

# Returns
- `j`: index of the best sensor, i.e. `adv.sensors[j]`.
- `v`: the robot's expected cost against it, f̄ ⋅ cⱼ.
"""
function best_response(adv::Adversary, f̄::AbstractVector{<:Real})
    fo_j = adv.O' * f̄                  # entry j = f̄ ⋅ oⱼ, for all sensors at once
    largest, j = findmax(fo_j)
    v = dot(f̄, adv.m) + largest        # f̄ ⋅ cⱼ = f̄ ⋅ m + f̄ ⋅ oⱼ
    return j, v
end