# AdversarialMDPs.jl

A Julia implementation of adversarial path planning in Markov Decision Processes (MDPs) using **Benders' Decomposition** and **Double Oracle** algorithms, based on the paper *"Planning in the Presence of Cost Functions Controlled by an Adversary"* (McMahan et al., 2003).

---

## 📁 Repository File Structure

```text
AdversarialMDPs/
├── README.md                  # Project overview and architecture documentation
├── Project.toml               # Julia dependencies (JuMP, HiGHS, Graphs, etc.)
├── src/
│   ├── AdversarialMDPs.jl     # Main module definition & public API exports
│   ├── environment.jl         # GridWorld state-action graph and sensor cost matrices
│   ├── utils.jl               # Path-to-flow conversion vector helpers
│   ├── direct_lp.jl           # Exact minimax LP solver (Ground truth baseline)
│   ├── single_oracle.jl       # Single Oracle / Benders' Decomposition (Eq. 6)
│   └── double_oracle.jl       # Double Oracle subgame iteration algorithm
├── test/
│   └── runtests.jl            # Unit tests verifying solvers against direct LP
└── scripts/
    └── run_benchmark.jl       # Benchmarking script for execution & convergence
```

---

## 📄 File Descriptions & Responsibilities

### Core Source Files (`src/`)

* **`AdversarialMDPs.jl`**
  * Serves as the package entry point.
  * Loads dependencies and exports primary structs (`GridWorld`, `Policy`, `CostMatrix`) and solver functions (`solve_direct_lp`, `solve_single_oracle`, `solve_double_oracle`).

* **`environment.jl`**
  * Defines the `GridWorld` environment layout ($N \times M$ grid, start state, goal state, obstacle masks).
  * Constructs state-action transition matrix $E$ and precomputes candidate sensor cost placement matrix $C$.

* **`utils.jl`**
  * Contains helper functions for discrete optimization.
  * Implements `path_to_flow(path, num_states, num_actions)`, translating state paths into sparse visitation frequency vectors $f \in \mathbb{R}^{|S||A|}$ required by the linear programs.

* **`direct_lp.jl`**
  * Solves the full zero-sum minimax matrix game directly using `JuMP.jl` (Equations 3 & 4 in the paper).
  * Provides exact ground truth values ($V^*$) used to test correctness of decomposition methods.

* **`single_oracle.jl`**
  * Implements Benders' decomposition for fixed candidate cost sets.
  * Formulates and solves the Master LP for opponent distribution $q$ (Equation 6) and calls Dijkstra's shortest-path algorithm as the Row Oracle best response.

* **`double_oracle.jl`**
  * Implements the full Double Oracle framework.
  * Maintains a restricted subgame matrix $\bar{R} \times \bar{C}$, iteratively computes equilibrium distributions $(p, q)$, and invokes both Row (Dijkstra) and Column (Sensor Placement) Oracles until convergence ($v_U - v_L < \epsilon$).

---

### Tests & Scripts

* **`test/runtests.jl`**
  * Unit tests using Julia's `Test` library.
  * Verifies that `solve_single_oracle` and `solve_double_oracle` converge to the exact same value as `solve_direct_lp` on small grids.

* **`scripts/run_benchmark.jl`**
  * Benchmark runner script comparing runtime, memory footprint, and iteration count across solver methods as grid size $|S|$ grows.

---

## 🚀 Recommended Implementation Sequence

1. **Environment Setup (`environment.jl` & `utils.jl`)**: Build the grid graph and test `path_to_flow`.
2. **Direct Baseline (`direct_lp.jl`)**: Solve a small $5 \times 5$ grid with direct JuMP LP.
3. **Single Oracle (`single_oracle.jl`)**: Implement Master LP + Dijkstra loop.
4. **Double Oracle (`double_oracle.jl`)**: Add subgame matrix management and joint oracle expansion.
