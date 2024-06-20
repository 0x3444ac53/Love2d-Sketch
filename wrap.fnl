(local love (require "love"))

(var circles [])


(var current-keys {})

(fn love.keyreleased [key]
  (tset current-keys key nil))


(fn love.keypressed [key]
  (tset current-keys key true))

(fn love.mousepressed [x y button]
  (tset current-keys :MOUSE true))

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
        (values k v)))))


(fn do-border-collision [tbl]
  (let [(width height _)  (love.window.getMode)]
    (when (> (+ tbl.p.x tbl.radius) width) (set tbl.v.x (* -1 (math.abs tbl.v.x))))
    (when (< (- tbl.p.x tbl.radius) 0) (set tbl.v.x (math.abs tbl.v.x)))
    (when (> (+ tbl.p.y tbl.radius) height) (set tbl.v.y (* -1 (math.abs tbl.v.y))))
    (when (< (- tbl.p.y tbl.radius) 0) (set tbl.v.y (math.abs tbl.v.y)))
    tbl))


(fn pa->pb [pa pb]
  (local d {:x (* 200 (- pb.x pa.x)) :y (* 200 (- pb.y pa.y))})
  (local md (math.pow (+ (math.pow d.x 2) (math.pow d.y 2)) .5))
  {:x (/ d.x md) :y (/ d.y md)})

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
    (love.graphics.printf (.. "ax:" (math.floor circle.a.x) " ay:" (math.floor circle.a.y)) 
                          (- circle.p.x circle.radius)
                          circle.p.y 
                         (* 2 circle.radius) :center 0)))
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
            :MOUSE (fn [tbl]
                     (tset tbl :a
                           (let [foo [(love.mouse.getPosition)]]
                             (let [{: x : y} (pa->pb tbl.p {:x (. foo 1) :y (. foo 2)})] 
                               {:x (* 400 x) :y (* 400 y)}))))}}))

