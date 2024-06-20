(local love (require "love"))

(var circle {:x 100 :y 100
              :vx 0 :vy 0
              :ax 20 :ay 20
              :radius 20})
(var current-keys {})

(fn love.keyreleased [key]
  (tset current-keys key nil))
(fn love.keypressed [key]
  (tset current-keys key true))
(fn love.load []
  (set circle 
       {:v {:x 0 :y 0}
        :a {:x 0 :y 0}
        :p {:x 100 :y 100}
        :radius 50
        :keys {:right (fn [tbl]
                        (set tbl.a.x 200))
               :left  (fn [tbl]
                        (set tbl.a.x -200))
               :down  (fn [tbl]
                        (set tbl.a.y 200))
               :up    (fn [tbl]
                        (set tbl.a.y -200))
               :g     (fn [tbl]
                        (set tbl.radius (math.abs (+ tbl.radius 20))))
               :h     (fn [tbl]
                        (set tbl.radius (math.abs (- tbl.radius 20))))}}))

(fn handle_keys [tbl current-keys key-map]
  (let []
    (var ntbl (collect [k v (pairs tbl)] (values k v)))
  (each [k _ (pairs current-keys)]
    ((. key-map k) ntbl))
  ntbl))


(fn do-forces [input-tbl dt]
  (let []
    (var tbl (collect [k v (pairs input-tbl)]
                (if (= k :v)
                  (values k
                    (let [{: x : y} v] ;could adapt to arbitrary dimensions with another collect
                      {:x (+ x (* dt input-tbl.a.x))
                       :y (+ y (* dt input-tbl.a.y))}))
                (values k v))))
    (collect [k v (pairs tbl)]
      (if (= k :p)
        (values k (let [{: x : y} v]
                    {:x (+ x (* dt tbl.v.x))
                     :y (+ y (* dt tbl.v.y))}))
        (values k v)))))
; separate out (f do_physics [obj])
(fn love.update [dt]
  (set circle.a.x 0)
  (set circle.a.y 0)
  (set circle 
       (do-forces
         (handle_keys circle 
                      current-keys circle.keys) dt))
    (set circle.v.x (* circle.v.x 0.9999)) ;should figure a way to do 
    (set circle.v.y (* circle.v.y 0.9999)) ;drag in do-forces
    (let [(width height _) (love.window.getMode)]
      (when (> (+ circle.p.x circle.radius) width) (set circle.v.x (* -1 (math.abs circle.vx))))
      (when (< (- circle.p.x circle.radius) 0) (set circle.v.x (math.abs circle.v.x)))
      (when (> (+ circle.p.y circle.radius) height) (set circle.v.y (* -1 (math.abs circle.vy))))
      (when (< (- circle.p.y circle.radius) 0) (set circle.v.y (math.abs circle.v.y)))))

(fn love.draw []
  (love.graphics.circle "line" circle.p.x circle.p.y circle.radius)
  (love.graphics.printf (.. "ax:" (math.floor circle.a.x) " ay:" (math.floor circle.a.y)) 
                        (- circle.p.x circle.radius)
                        circle.p.y 
                        (* 2 circle.radius) :center 0))

