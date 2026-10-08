include("../src/AdversarialMDPs.jl")

if abspath(PROGRAM_FILE) == @__FILE__
    AdversarialMDPs.demo(ARGS)
end