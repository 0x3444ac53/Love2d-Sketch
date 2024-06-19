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
  (set NorasCircle.radius 2))
(fn love.update [dt]
  (let [pos-delta (* 100 dt)]
  (when (. current-keys :right)
    (tset NorasCircle :x (+ NorasCircle.x pos-delta)))
  (when (. current-keys :left)
    (tset NorasCircle :x (- NorasCircle.x pos-delta)))
  (when (. current-keys :up)
    (tset NorasCircle :y (- NorasCircle.y pos-delta)))
  (when (. current-keys :down)
    (tset NorasCircle :y (+ NorasCircle.y pos-delta)))
  (when  (. current-keys :g) 
    (tset NorasCircle :radius (+ NorasCircle.radius pos-delta)))
  (when (. current-keys :h)
    (tset NorasCircle :radius (- NorasCircle.radius pos-delta)))))
(fn love.draw []
  (love.graphics.circle "line" NorasCircle.x NorasCircle.y NorasCircle.radius))

