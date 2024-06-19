(local love (require "love"))

(var NorasCircle {})
(var current-keys {})

(fn love.keyreleased [key]
  (tset current-keys key nil))
(fn love.keypressed [key]
  (tset current-keys key true))
(fn love.load []
  (set NorasCircle.x 0)
  (set NorasCircle.y 0)
  (set NorasCircle.vx 0)
  (set NorasCircle.vy 0)
  (set NorasCircle.ax 0)
  (set NorasCircle.ay 0)
  (set NorasCircle.radius 2))

(fn handle_physics [tbl dt keys]
  (collect [k _ (pairs keys)]
           (let [ax 0 ay 0]
             (when (= k :down)
               (set ay 50))
             (when (= k :up)
               (set ay -50))
             (when (= k :left)
               (set ax -50))
             (when (= k :right)
               (set ax 50)))
           ))
; this was a bad idea, please fix 

  ; (let [{:x x :y y :vx vx :vy vy} NorasCircle]
    ; (set NorasCircle.x (+ x (* vx dt)))
    ; (set NorasCircle.y (+ y (* vy dt)))))


(fn love.update [dt]
  )
(fn love.draw []
  (love.graphics.circle "line" NorasCircle.x NorasCircle.y NorasCircle.radius))

