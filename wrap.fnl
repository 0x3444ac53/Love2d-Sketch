(local love (require "love"))

(var circles [])


(var current-keys {})

(local v2->v2 (fn [v2 tx ty]
  {:x (tx v2.x) :y (ty v2.y)}))

(fn love.keyreleased [key]
  (tset current-keys key nil))


(fn love.keypressed [key]
  (tset current-keys key true))

(fn love.mousepressed [x y b]
  (tset current-keys :MOUSE {:x x :y y :b b}))

(fn love.mousereleased [x y button]
  (tset current-keys :MOUSE nil))


(fn handle_keys [tbl current-keys key-map]
  (let []
    (var ntbl (collect [k v (pairs tbl)] (values k v)))
  (each [k _ (pairs current-keys)]
    (let [ok? (. key-map k)] 
      (when ok? 
        (ok? ntbl))))
  ntbl))

(fn do-forces [input-tbl dt]
    (var tbl (collect [k v (pairs input-tbl)] ;; Updates Velocity from Acceleration
                (if (= k :v)
                  (values k (v2->v2 v #(+ $1 (* dt input-tbl.a.x)) #(+ $1 (* dt input-tbl.a.y))))
                (values k v))))
    (collect [k v (pairs tbl)] ; updates position by velocity
      (if (= k :p)
        (values k (v2->v2 v #(+ $1 (* dt tbl.v.x)) #(+ $1 (* dt tbl.v.y))))
        (values k v))))

(fn do-border-collision [tbl]
  (let [ntbl (collect [k v (pairs tbl)] (values k v))]
    (let [(width height _)  (love.window.getMode)]
      (when (>= (+ ntbl.p.x ntbl.radius) width) (set ntbl.v.x (- (math.abs ntbl.v.x))))
      (when (<= (- ntbl.p.x ntbl.radius) 0) (set ntbl.v.x (math.abs ntbl.v.x)))
      (when (>= (+ ntbl.p.y ntbl.radius) height) (set ntbl.v.y (- (math.abs ntbl.v.y))))
      (when (<= (- ntbl.p.y ntbl.radius) 0) (set ntbl.v.y (math.abs ntbl.v.y)))
    ntbl)))

(fn mag [{: x : y} v]
  (math.pow (+ (math.pow x 2) (math.pow y 2)) .5))

(when nil 15)

(fn norm [v0]
  (let [m (if (= 0 (mag v0)) 1)]
  (collect [k v (pairs v0)]
    (values k (/ v m)))))

(fn pa->pb [pa pb]
  (norm (v2->v2 pa #(- pb.x $1) #(- pb.y $1))))

(fn love.update [dt]
  (set circles
       (let [tbl []]
         (each [_ circle (ipairs circles)]
           (set circle.a.x 0)
           (set circle.a.y 0)
           (tset tbl (+ (length tbl) 1)
                 (do-border-collision 
                   (do-forces
                     (handle_keys circle current-keys circle.keys) dt))))
         tbl)))

(fn love.draw []
  (each [_ circle (pairs circles)]
    (love.graphics.circle "line" circle.p.x circle.p.y circle.radius)
    (love.graphics.print (.. "vx:" circle.v.x "vy:" circle.v.y) 
                          100
                          100)))



 (fn love.load []
  (love.window.setMode 0 0 {:fullscreen true})
  (table.insert 
    circles 1 
    {:v {:x 0 :y 0}
     :a {:x 0 :y 0}
     :p {:x 500 :y 500}
     :df 0.99
     :radius 50
     :keys {:right #(tset (. $1 :a) :x 200)
            :left  #(tset (. $1 :a) :x -200)
            :down  #(tset (. $1 :a) :y 200)
            :up    #(tset (. $1 :a) :y -200)
            :g     #(tset $1 :radius (math.abs (+ (. $1 :radius ) 20)))
            :h     #(tset $1 :radius (math.abs (- (. $1 :radius) 20)))
            :MOUSE #($)}}))

