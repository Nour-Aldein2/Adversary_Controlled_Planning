### A Pluto.jl notebook ###
# v1.1.0

using Markdown
using InteractiveUtils

# ╔═╡ 0755b5dc-d2e6-11f1-a771-5f3f49168a19
   begin
       import Pkg
       Pkg.activate(Base.current_project())   # your Project.toml, found from notebooks/
       using AdversarialMDPs, Random
   end

# ╔═╡ 782747d0-ac9f-4974-991d-38a679d2f0cc
import AdversarialMDPs as ad

# ╔═╡ d44dab63-584c-412c-9c77-1c752d5263c5
md"""
## Create the room

The first step is to make the room where the players will operate.
"""

# ╔═╡ ddef0b3a-ff99-4e58-8e97-1b902716fd68
width, height = 8, 8

# ╔═╡ cd4869fe-b246-4bce-af4e-00a2e1bb68ac
walls = fill(false, height, width)

# ╔═╡ ce217ca2-1bba-4aee-9a4a-000b947b50f6
room = Room(walls, CartesianIndex(1, 1), [CartesianIndex(height, width)])

# ╔═╡ 3fcc5eb1-73d9-431d-a42f-58e713805d8c
md"""
## Create Players

Next, we create the sensors
"""

# ╔═╡ 1c8421c4-b9c8-495c-a70d-dc29a0481a45
rng = Xoshiro(7)

# ╔═╡ 5e84d997-4dad-4b72-8083-a00f45056dd9
sensors = random_sensors(rng, room, 1, 3)

# ╔═╡ 16840ced-9075-4036-8c0d-0ce4e93cfc02
for s in sensors
    println("Sensor at ", Tuple(s.position), " facing ", ad.DIRECTIONS[s.direction])
end

# ╔═╡ bef2a819-bc93-473f-a4e9-f0e5858de285
print_room(room, sensors)

# ╔═╡ ce28d9ea-e5e8-4e5c-ac6b-39c37084b0ec
md"""
Next is to create a robot
"""

# ╔═╡ f12f1fa0-212b-4307-8f6c-bf768ec23cf9


# ╔═╡ Cell order:
# ╠═0755b5dc-d2e6-11f1-a771-5f3f49168a19
# ╠═782747d0-ac9f-4974-991d-38a679d2f0cc
# ╟─d44dab63-584c-412c-9c77-1c752d5263c5
# ╠═ddef0b3a-ff99-4e58-8e97-1b902716fd68
# ╠═cd4869fe-b246-4bce-af4e-00a2e1bb68ac
# ╠═ce217ca2-1bba-4aee-9a4a-000b947b50f6
# ╟─3fcc5eb1-73d9-431d-a42f-58e713805d8c
# ╠═1c8421c4-b9c8-495c-a70d-dc29a0481a45
# ╠═5e84d997-4dad-4b72-8083-a00f45056dd9
# ╠═16840ced-9075-4036-8c0d-0ce4e93cfc02
# ╠═bef2a819-bc93-473f-a4e9-f0e5858de285
# ╟─ce28d9ea-e5e8-4e5c-ac6b-39c37084b0ec
# ╠═f12f1fa0-212b-4307-8f6c-bf768ec23cf9
