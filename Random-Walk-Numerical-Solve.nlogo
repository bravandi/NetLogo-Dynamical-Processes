;;;testtest

extensions [ nw matrix ]

globals [adj PAnetwork? ]

turtles-own [w w-prev]

;; Create nodes.
to setup
  clear-all
  reset-ticks

  wire-network

  ask turtles [
    set shape "circle"
    ;set color scale-color green count link-neighbors 50 0
    ;set size 0.5
    ;setxy random-xcor random-ycor
  ]

  ;set p 0.25
  reset
end

to reset
  print "RESET!"
  let num_tu round total_walkers / num-nodes-start-with-walker

  ask turtles [
    set w 0
  ]

  ask n-of num-nodes-start-with-walker turtles [
    set w num_tu
    set w-prev num_tu
    set label who
  ]

  ;reset-ticks
  apply-style
end

to apply-style
  ask turtles [
    let new-size w / 4

    if new-size > 5 [ set new-size 5.0 ]

    if new-size < 0.1 [ set new-size 0.25 ]

    set size new-size
  ]

end

to go
  ;print "GO!"

  ask turtles [
    let i who
    ;print (word "I am:" i)
    let out w-prev * Move-Out-Rate

    let in 0

    let j 0
    while [j < count turtles] [

      let neighbor-degree sum matrix:get-column adj j

      if neighbor-degree > 0 [

        set in (in + (matrix:get adj j i) * (Move-Out-Rate / neighbor-degree) * ([w-prev] of turtle j))
      ]

      set j (j + 1)
    ]

    let new-w (w - out + in)

    if new-w < 0 [ set new-w 0 ]

    set w new-w
  ]

  ;print-w

  ask turtles [ set w-prev w ]

  apply-style
  tick
end


to wire-network

  if network-model = "Erdős–Rényi" [
    nw:generate-random turtles links num-nodes average-degree / num-nodes
  ]

  if network-model = "Barabási–Albert" [
    nw:generate-preferential-attachment turtles links num-nodes average-degree
  ]

  if network-layout = "Spring Layout"[
    repeat 100 [ layout-spring turtles links 0.1 10 1 ] ;; lays the nodes in a triangle
  ]

  if network-layout = "Circular Degree Sorted Layout" [
    layout-circle sort-by [ [a b] -> [count link-neighbors] of a < [count link-neighbors] of b ] turtles 14
  ]

  ;layout-spring turtles links 0.2 5 1

  ;layout

  let file-name "net-adj.txt"

  nw:save-matrix file-name

  let matrix-list []

  file-open file-name
  while [not file-at-end?]
  [
    let line file-read-line

    let a read-from-string (word"[" line "]")

    set matrix-list lput a matrix-list
  ]
  file-close

  print "ROW LIST"
  print matrix-list
  ;print matrix:from-row-list [[0.00 1.00 0.00 ] [1.00 0.00 1.00 ] [0.00 1.00 0.00 ]]
  print "MAT"
  set adj matrix:from-row-list matrix-list
  print adj
end


to layout
  ;; the number 3 here is arbitrary; more repetitions slows down the
  ;; model, but too few gives poor layouts
  repeat 3 [
    ;; the more turtles we have to fit into the same amount of space,
    ;; the smaller the inputs to layout-spring we'll need to use
    let factor sqrt count turtles
    ;; numbers here are arbitrarily chosen for pleasing appearance
    layout-spring turtles links (1 / factor) (7 / factor) (1 / factor)
    display  ;; for smooth animation
  ]
  ;; don't bump the edges of the world
  let x-offset max [xcor] of turtles + min [xcor] of turtles
  let y-offset max [ycor] of turtles + min [ycor] of turtles
  ;; big jumps look funny, so only adjust a little each time
  set x-offset limit-magnitude x-offset 0.1
  set y-offset limit-magnitude y-offset 0.1
  ask turtles [ setxy (xcor - x-offset / 2) (ycor - y-offset / 2) ]
end

to-report limit-magnitude [number limit]
  if number > limit [ report limit ]
  if number < (- limit) [ report (- limit) ]
  report number
end

to-report calc-pct [ #pct #vals ]
  let #listvals sort #vals
  let #pct-position #pct / 100 * length #vals
  ; find the ranks and values on either side of the desired percentile
  let #low-rank floor #pct-position
  let #low-val item #low-rank #listvals
  let #high-rank ceiling #pct-position
  let #high-val item #high-rank #listvals
  ; interpolate
  ifelse #high-rank = #low-rank
  [ report #low-val ]
  [ report #low-val + ((#pct-position - #low-rank) / (#high-rank - #low-rank)) * (#high-val - #low-val) ]
end

to-report avg-walkers [quartile]
  let degree-list [count my-links] of turtles

  let range-lower min(degree-list)
  let range-upper max(degree-list) + 1

  if quartile > 0 [
    set range-lower calc-pct (quartile * 25) degree-list
  ]

  if quartile < 3 [
    set range-upper calc-pct ((quartile + 1) * 25) degree-list
  ]

  let selected-walkers []

  ask turtles [
    if (range-lower <= count my-links) and (count my-links < range-upper) [

      set selected-walkers lput (w) selected-walkers ; (count my-links)
    ]
  ]

  report mean selected-walkers
  ;report (word range-lower ", " range-upper "->" selected-walkers)
end

to-report get-degree-list
  report sort remove-duplicates [count my-links] of turtles
end

to-report get-mean-degree-mean-walkers
  let mean-walkers []

  foreach (get-degree-list) [ deg ->
    set mean-walkers lput (mean [w] of turtles with [ count my-links = deg]) mean-walkers
  ]

  report mean-walkers
end


to print-w
  let out "W -> "

  foreach (sort [who] of turtles) [ x -> set out (word out "N" x ":" ([precision w 10] of turtle x) " ") ]

  print out
end
@#$#@#$#@
GRAPHICS-WINDOW
235
10
1038
814
-1
-1
24.1
1
10
1
1
1
0
0
0
1
-16
16
-16
16
1
1
1
ticks
30.0

BUTTON
0
325
75
358
NIL
setup
NIL
1
T
OBSERVER
NIL
S
NIL
NIL
1

SLIDER
0
60
225
93
num-nodes
num-nodes
10
500
100.0
5
1
NIL
HORIZONTAL

SLIDER
0
95
225
128
average-degree
average-degree
1
10
6.6
0.1
1
NIL
HORIZONTAL

MONITOR
0
430
61
475
max-deg
max [count link-neighbors] of turtles
1
1
11

MONITOR
137
430
194
475
#links
count links
1
1
11

MONITOR
67
430
133
475
min-deg
min [count link-neighbors] of turtles
1
1
11

BUTTON
85
325
170
358
NIL
go
T
1
T
OBSERVER
NIL
G
NIL
NIL
1

BUTTON
0
365
165
398
NIL
reset
NIL
1
T
OBSERVER
NIL
R
NIL
NIL
1

PLOT
1095
35
1590
410
Avg Walkers in Degree Quartiles
time
avg walkers
0.0
6.0
0.0
5.0
true
true
"" ""
PENS
"Q1" 1.0 0 -16777216 true "" "plot avg-walkers 0"
"Q2" 1.0 0 -6459832 true "" "plot avg-walkers 1"
"Q3" 1.0 0 -13840069 true "" "plot avg-walkers 2"
"Q4" 1.0 0 -955883 true "" "plot avg-walkers 3"

SLIDER
0
210
225
243
Move-Out-Rate
Move-Out-Rate
0
1
0.1
0.05
1
NIL
HORIZONTAL

SLIDER
0
250
225
283
total_walkers
total_walkers
500
1000
600.0
100
1
NIL
HORIZONTAL

PLOT
1090
445
1490
760
Degree vs Average Number of Walkers
degree
avg walkers
0.0
15.0
0.0
10.0
false
false
"" "clear-plot"
PENS
"pen-0" 1.0 2 -16777216 true "" "let deg-l get-degree-list\nlet w-means []\nlet w-mean 0\n\nforeach (get-degree-list) [ deg -> \n  set w-mean mean [w] of turtles with [ count my-links = deg]\n  set w-means lput w-mean w-means\n  plotxy deg w-mean\n]\n\nset-plot-y-range 0 (round (max w-means)) + 1\n\nset-plot-x-range 0 (max deg-l + 1)"

PLOT
0
485
225
745
Degree Distribution
Degree
# of nodes
1.0
10.0
0.0
10.0
true
false
"clear-plot" "clear-plot"
PENS
"default" 1.0 1 -16777216 false "" "let max-degree max [count link-neighbors] of turtles\nplot-pen-reset  ;; erase what we plotted before\nset-plot-x-range 1 (max-degree + 1)  ;; + 1 to make room for the width of the last bar\nhistogram [count link-neighbors] of turtles"

SLIDER
0
285
225
318
num-nodes-start-with-walker
num-nodes-start-with-walker
1
num-nodes
3.0
1
1
NIL
HORIZONTAL

CHOOSER
0
10
225
55
network-model
network-model
"Erdős–Rényi" "Barabási–Albert"
0

CHOOSER
0
130
225
175
network-layout
network-layout
"Circular Degree Sorted Layout" "Spring Layout"
0

@#$#@#$#@
## ACKNOWLEDGEMENT

## WHAT IS IT?

This model demonstrates a deterministic simulation of a simple random walk process. Individuals move from one node to another depending on a fixed diffusion probability. This phenomenon also depends on the degree of the neighboring nodes.
This model may be useful in understanding the basic properties of dynamic processes on networks and can be extended to a stochastic version. 

## HOW IT WORKS

For a given random network, a certain number of walkers are placed on a random node. Then temporal recursive equations are used compute the number of walkers at every node in the graph. There are two components of the random walk for a given node. The OUT component considers some walkers move out of a node with a fixed predefined probability. The IN component adds up all the walkers coming from the neighboring nodes. Walkers move out of the neighboring nodes with the same diffusion probability and gets distributed uniformly across all the links connected to it.
In the visualization, size of a node at each time stamp is proportional to the number of walkers on it. 

## HOW TO USE IT

Choose the size of network that you want to model using the NODE-COUNT slider. Choose the expected density of links in the network using the LINK-COUNT slider.
To create the Erdős–Rényi network with these properties, press SETUP.
The TOTAL-WALKERS slider controls how many walkers needs to be placed on a random node to begin the process. 
Press the GO button to run the model.
The number of walkers for a given input degree node is also visualized over time. 

## THINGS TO NOTICE

Over time, the number of walkers on each node saturates. The final steady-state value of walkers depends on the degree of a node. 
Irrespective of whether the initial walkers are concentrated on a single node or distributed across multiple nodes, same steady state is achieved for all the nodes. 
Since this model uses deterministic equations, the number of walkers can be fractional. More realistic simulation can be achieved via the stochastic model.

## THINGS TO TRY

Try running the model with a fixed number of nodes and links. Observe the plots for different degree nodes. Try increasing the number of nodes and links and observe when the number of walkers on a node starts saturating. Try the simulations by placing all the walkers on a single node and distributing the walkers across multiple nodes initially.

## EXTENDING THE MODEL

A more realistic simulation can be done using the stochastic version of the random walk model. Instead of multiplying the diffusion probability to get the number of walkers diffusing from a node at a given instance, an integer number is chosen based on multinomial distributions. This shows similar temporal behavior of the number of walkers across all the nodes with noise added on the trend seen in the deterministic model.

## RELATED MODELS

Stochastic Random Walk

## NETLOGO FEATURES

This model can be simulated on different network architectures beyond the Erdős–Rényi graphs. Integration of this deterministic model with small world and Barabási–Albert network models shall allow the users to study the effects of network architecture and degree distribution on the random walk process.

## HOW TO CITE

If you mention this model or the NetLogo software in a publication, we ask that you include the citations below.

For the model itself:

TBD (2020). NetLogo Models for studying Dynamical Processes on Complex Networks, Northeastern University, Boston, MA.

Please cite the NetLogo software as:

Wilensky, U. (1999). NetLogo. http://ccl.northwestern.edu/netlogo/. Center for Connected Learning and Computer-Based Modeling, Northwestern University, Evanston, IL.

## COPYRIGHT AND LICENSE

Copyright 2008 Uri Wilensky.
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.1.1
@#$#@#$#@
setup wire1
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
1
@#$#@#$#@
