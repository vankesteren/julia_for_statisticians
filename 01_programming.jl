# basic programming in julia
using LinearAlgebra

# Vectors and broadcasting
# two vectors
v = [2, 3, 4, 5]
w = [.2, .2, .4, .6]

# trying to do multiplication
v * w # error!!

# do you want an inner product?
transpose(v)*w
# or
v'w

# do you want elementwise multiplication?
v .* w # dot syntax to "broadcast" the operation

# string stuff and pythonic list comprehension!!
vchar = ["value $i" for i in v]
wchar = ["weight $j" for j in w]
["$i times $j equals $(round(k; digits=2))" for (i, j, k) in zip(v, w, v.*w)]

# Matrices
A = [
    4 2 1
    3 8 6
    7 5 9
]

B = [
    2 3 4
    1 2 3
]

# Matrix multiplication
B*A

# Matrix solving like in matlab
B'\A

# Matrix factorization
svd(A)

# the identity matrix is a special object
# which is never really instantiated
A + 5*I


# functions
function my_function(x::Number, y::Number; σ::Real = 1.0)
    r = (x - y) / σ
    return sqrt(r^2)
end

my_function(3, -2)
my_function(v, w) # error! the inputs are not numbers
my_function.(v, w) # broadcasting any function

# type system: let's make the function work on vectors!
function my_function(x::Vector, y::Vector; σ::Real = 1.0)
    r = (x .- y) ./ σ
    return norm(r)
end

my_function(v, w) # now it does work for vectors


# loops and programming control flow
function my_loop_function(x::Vector, y::Vector; σ::Real = 1.0)
    accumulator = 0.0
    for i in 1:length(x)
        accumulator += (x[i] - y[i] / σ)^2
    end
    return √accumulator
end

my_loop_function(v, w) # same result!

# this must be slower right?
using BenchmarkTools

big_v = 1:-0.01:0
big_w = 0:0.01:1

# to instantiate these ranges we can collect()
collect(big_v)
# but not necessary to actually do that

# this @benchmark
@benchmark my_function(v, w)
@benchmark my_loop_function(v, w)

# !! speed like C++ 🙂


# Object-oriented programming
# create objects

# a positionvector and distance method
struct PositionVector
    x::Number
    y::Number
end
distance(a::PositionVector, b::PositionVector) = norm([a.x, a.y]-[b.x, b.y])

# a mood object and functions to improve and decrease mood
@enum Mood ☹️ 😐 🙂
bleh(m::Mood) = m == 🙂 ? 😐 : ☹️
yay(m::Mood) = m == ☹️ ? 😐 : 🙂

# and agent with a name and position and mood
mutable struct Agent
    name::String
    pos::PositionVector
    state::Mood
end

function Base.show(io::IO, a::Agent)
    println(io, "Agent $(a.name):")
    println(io, "  - Located at $(a.pos.x), $(a.pos.y).")
    println(io, "  - Currently in a $(a.state) mood.")
end

# we should be able to directly use these methods on agents
distance(a::Agent, b::Agent) = distance(a.pos, b.pos)
bleh(a::Agent) = a.state = bleh(a.state);
yay(a::Agent) = a.state = yay(a.state);

# agents should be able to move
moveto(a::Agent, x::Number, y::Number) = a.pos = PositionVector(x, y)

# define an interaction
function interact(a::Agent, b::Agent)
    if distance(a.pos, b.pos) > 1
        bleh.([a, b]);
    else
        yay.([a, b]);
    end
    show.([a, b])
    return
end

# let's try it out!
alice = Agent("Alice", PositionVector(1, 1), Mood(2))
bob = Agent("Bob", PositionVector(0, 0), Mood(1))

interact(bob, alice)
distance(bob, alice)

moveto(bob, .5, .5)
distance(bob, alice)

interact(bob, alice)
