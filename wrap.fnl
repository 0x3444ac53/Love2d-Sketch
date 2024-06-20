(local love (require "love"))

(var circle {:x 100 :y 100
              :vx 0 :vy 0
              :ax 0 :ay 0
              :radius 20})
(var current-keys {})

(fn love.keyreleased [key]
  (tset current-keys key nil))
(fn love.keypressed [key]
  (tset current-keys key true))
(fn love.load []
  (set circle 
       {:x 100 :y 100
        :vx 0 :vy 0
        :ax 0 :ay 0
        :radius 50}))

(fn handle_keys [tbl current-keys key-map]
  (each [k _ (pairs current-keys)]
    ((. key-map k) tbl)))

; separate out (f do_physics [obj])
(fn love.update [dt]
  (set circle.ax 0)
  (set circle.ay 0)
  (handle_keys 
    circle 
    current-keys 
    {:right (fn [tbl]
              (set tbl.ax 100))
     :left (fn [tbl]
             (set tbl.ax -100))
     :down (fn [tbl]
             (set tbl.ay 100))
     :up   (fn [tbl]
             (set tbl.ay -100))})
    (set circle.vx (+ circle.vx (* dt (. circle :ax))))
    (set circle.vy (+ circle.vy (* dt circle.ay)))
    (set circle.x  (+ circle.x  (* dt circle.vx)))
    (set circle.y  (+ circle.y  (* dt circle.vy)))
    (set circle.vx (* circle.vx 0.99))
    (set circle.vy (* circle.vy 0.99))
    (let [(width height _) (love.window.getMode)]
    (when (> (+ circle.x circle.radius) width) (set circle.vx (* -1 (math.abs circle.vx))))
    (when (< (- circle.x circle.radius) 0) (set circle.vx (math.abs circle.vx)))
    (when (> (+ circle.y circle.radius) height) (set circle.vy (* -1 (math.abs circle.vy))))
    (when (< (- circle.y circle.radius) 0) (set circle.vy (math.abs circle.vy))))
    (print (.. "x:" circle.x " y:" circle.y 
                             " vy: " circle.vy " vx:" circle.vx) 100 100))

(fn love.draw []
  (love.graphics.circle "line" circle.x circle.y circle.radius))

