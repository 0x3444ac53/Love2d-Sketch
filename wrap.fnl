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

(fn handle_keys [current-keys tbl]
  (let []
    (var ntbl (collect [k v (pairs tbl)] (values k v)))
    (each [k v (pairs ntbl.keys)]
      (if (. current-keys k) (v ntbl) ))
    ntbl))


(fn do-forces [dt input-tbl]
  (collect [k v (pairs input-tbl)] ;; Updates Velocity from Acceleration
    (if (= k :v)
      (values k (v2->v2 v #(* (+ $1 (* dt input-tbl.a.x)) input-tbl.fc) #(* input-tbl.fc (+ $1 (* dt input-tbl.a.y)))))
    (if (= k :a)
      (values k (v2->v2 v #(+ 0) #(+ 0)))
      (values k v)))))

(fn do-position [dt input-tbl]
    (collect [k v (pairs input-tbl)] ; updates position by velocity
      (if (= k :p)
        (values k (v2->v2 v #(+ $1 (* dt input-tbl.v.x)) #(+ $1 (* dt input-tbl.v.y))))
        (values k v))))

(fn do-border-collision [w h tbl]
  (let [ntbl (collect [k v (pairs tbl)] (values k v))]
      (when (>= (+ ntbl.p.x ntbl.radius) w) (set ntbl.v.x (* .8 (- (math.abs ntbl.v.x)))))
      (when (<= (- ntbl.p.x ntbl.radius) 0) (set ntbl.v.x (* .8 (math.abs ntbl.v.x))))
      (when (>= (+ ntbl.p.y ntbl.radius) h) (set ntbl.v.y (* .8 (- (math.abs ntbl.v.y)))))
      (when (<= (- ntbl.p.y ntbl.radius) 0) (set ntbl.v.y (* .8 (math.abs ntbl.v.y))))
    ntbl))

(fn mag [{: x : y} v]
  (math.pow (+ (math.pow x 2) (math.pow y 2)) .5))

(fn norm [v0]
  (let [m (if (= 0 (mag v0)) 1)]
  (collect [k v (pairs v0)]
    (values k (/ v m)))))

(fn pa->pb [pa pb]
  (norm (v2->v2 pa #(- pb.x $1) #(- pb.y $1))))

(fn love.update [dt]
  (set circles
       (let [tbl []]
         (let [(w h _) (love.window.getMode)]
           (each [_ circle (ipairs circles)]
             (tset tbl (+ (length tbl) 1)
                   (->> circle
                        (handle_keys current-keys)
                        (do-forces dt)
                        (do-position dt)
                        (do-border-collision w h)))))
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
 circles {:v {:x 0 :y 0}
          :a {:x 0 :y 0}
          :p {:x 500 :y 500}
          :fc 1
          :radius 50
          :keys {:right #(tset (. $1 :a) :x 200)
                 :left  #(tset (. $1 :a) :x -200)
                 :down  #(tset (. $1 :a) :y 200)
                 :up    #(tset (. $1 :a) :y -200)
                 :g     #(tset $1 :radius (math.abs (+ (. $1 :radius ) 20)))
                 :h     #(tset $1 :radius (math.abs (- (. $1 :radius) 20)))}})
1)


; ; (var tbl {:a {:x 200 :y 200}
; ;          :p {:x 500 :y 500}
; ;          :v {:x 0 :y 0}
; ;          :radius 50
; ;          :fc 1
; ;          :keys {:down  #<function: 0x0105293f88>
; ;                 :g     #<function: 0x0105293fe8>
; ;                 :h     #<function: 0x0105294018>
; ;                 :left  #<function: 0x0104d1cce0>
; ;                 :right #<function: 0x0104d1c640>
; ;                 :up    #<function: 0x0105293fb8>}}
; ;
; ; (var current-keys {:right true :down true})
; ; (var dt 1)
; ; (var width 1000)
; ; (var height 1000)
; (->> tbl
;      (handle_keys current-keys)
;      (do-forces dt)
;      (do-position dt)
;      (do-border-collision width height)
; ; {:a {:x 0 :y 0}
; ;  :df 0.99
; ;  :keys {:down #<function: 0x0105293f88>
; ;         :g #<function: 0x0105293fe8>
; ;         :h #<function: 0x0105294018>
; ;         :left #<function: 0x0104d1cce0>
; ;         :right #<function: 0x0104d1c640>
; ;         :up #<function: 0x0105293fb8>}
; ;  :p {:x 700 :y 700}
; ;  :radius 50
; ;  :v {:x 200 :y 200}}
;      (handle_keys current-keys)
;      (do-forces dt)
;      (do-position dt)
;      (do-border-collision width height)
; ; {:a {:x 0 :y 0}
; ;  :df 0.99
; ;  :keys {:down #<function: 0x0105293f88>
; ;         :g #<function: 0x0105293fe8>
; ;         :h #<function: 0x0105294018>
; ;         :left #<function: 0x0104d1cce0>
; ;         :right #<function: 0x0104d1c640>
; ;         :up #<function: 0x0105293fb8>}
; ;  :p {:x 1100 :y 1100}
; ;  :radius 50
; ;  :v {:x -320 :y -320}}
;      (handle_keys current-keys)
;      (do-forces dt)
;      (do-position dt)
;      (do-border-collision width height))
; ; {:a {:x 0 :y 0}
; ;  :df 0.99
; ;  :keys {:down #<function: 0x0105293f88>
; ;         :g #<function: 0x0105293fe8>
; ;         :h #<function: 0x0105294018>
; ;         :left #<function: 0x0104d1cce0>
; ;         :right #<function: 0x0104d1c640>
; ;         :up #<function: 0x0105293fb8>}
; ;  :p {:x 980 :y 980}
; ;  :radius 50
; ;  :v {:x -96 :y -96}}
