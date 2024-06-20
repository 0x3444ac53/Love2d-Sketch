{:v {:x 0 :y 0}
 :a {:x 0 :y 0}
 :p {:x 100 :y 100}
 :df 0.999
 :radius 50
 :keys {:right #(tset (. $1 :a) :x 200)
        :left  #(tset (. $1 :a) :x -200)
        :down  #(tset (. $1 :a) :y 200)
        :up    #(tset (. $1 :a) :y -200)
        :g     #(tset $1 :radius (math.abs (+ (. $1 :radius ) 20)))
        :h     #(tset $1 :radius (math.abs (- (. $1 :radius) 20)))}}
