(local love (require "love"))

(var circles [])

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
  (love.window.setMode 0 0 {:fullscreen true})
  (set
    circle (require :fnl.circle)))

(fn handle_keys [tbl current-keys key-map]
  (let []
    (var ntbl (collect [k v (pairs tbl)] (values k v)))
  (each [k _ (pairs current-keys)]
    (let [ok? (. key-map k)] 
      (ok? ntbl)))
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
        (values k (let [{: x : y} v df? (. tbl :df)]
                    {:x (* (if df? df? 1) (+ x (* dt tbl.v.x)))
                     :y (* (if df? df? 1) (+ y (* dt tbl.v.y)))}))
        (values k v)))
    ))



; separate out (f do_physics [obj])
(fn love.update [dt]
  (set circle.a.x 0)
  (set circle.a.y 0)
  (set circle
       (do-forces
         (handle_keys circle 
                      current-keys circle.keys) dt))
    (let [(width height _) (love.window.getMode)]
      (when (> (+ circle.p.x circle.radius) width) (set circle.v.x (* -1 (math.abs circle.v.x))))
      (when (< (- circle.p.x circle.radius) 0) (set circle.v.x (math.abs circle.v.x)))
      (when (> (+ circle.p.y circle.radius) height) (set circle.v.y (* -1 (math.abs circle.v.y))))
      (when (< (- circle.p.y circle.radius) 0) (set circle.v.y (math.abs circle.v.y)))))

(fn love.draw []
  (love.graphics.circle "line" circle.p.x circle.p.y circle.radius)
  (love.graphics.printf (.. "ax:" (math.floor circle.a.x) " ay:" (math.floor circle.a.y)) 
                        (- circle.p.x circle.radius)
                        circle.p.y 
                        (* 2 circle.radius) :center 0))
