;;source

(define l 0.5)

(define d (vector3 2 0 0))

(define s 3)

(define h 10)

(define sig 1)

;;geometry

(define r2 20)

(define r1 10)

;;

(define lat (+ r1 r2 r1 r2))

(set! geometry-lattice
        (make lattice
                (size lat lat no-size)
        )
)

(define dr (- r2 r1))

(define c (/ r2 dr))

(define (special r)
        (if (>= (sqrt(+(expt (vector3-x r) 2)(expt (vector3-y r) 2))) r1 )
                (let
                        (
                                (x (vector3-x r))
                                (y (vector3-y r))
                                (dd (sqrt(+(expt (vector3-x r) 2)(expt (vector3-y r) 2))))
                        )
                        (let
                                (
                                        (i (/(* c (expt(- dd r1)1))(expt dd 3)))
                                        (j (/ c (expt dd 2)))
                                )
                                (let
                                        (
                                                (a (+ (* x x j) (* y y i)))
                                                (b (+ (* y y j) (* x x i)))
                                                (d (+ 0.001 (- (* x y j) (* x y i))))
                                        )
                                        (make dielectric
;                                                 (epsilon-diag a b c)
;                                                 (epsilon-offdiag d 0 0)
;                                                 (mu-diag a b c)
;                                                 (mu-offdiag d 0 0)
                                                  (epsilon-diag a b c)
						  (epsilon-offdiag d 0 0)
						  (mu-diag a b c)
						  (mu-offdiag d 0 0)
                                        )
                                )
                        )
                )
                (make perfect-metal)
        )
)

(set! geometry
        (list
                (make cylinder
	        	(center 0 0)
		        (radius r2)
                        (height infinity)
;        		(material-func special)
                        (material (make material-function
                                (material-func special))
                        )
                )
        )
)

(define ((my-amp sigma k) x)
        (exp(-
                (* 0+2i pi (vector3-dot k x))
                (/ (vector3-dot x x) (* 2 sigma sigma)))
        )
)

(set! sources
        (list
                (make source
                        (src
                                (make continuous-src
                                        (wavelength l)
                                )
                        )
                        (component Ey)
                        (center (- 0 (+ r2 (/ r1 2))) h)
                        (amp-func (my-amp sig d))
                        (size s s 0)
                )
        )
)

(set! pml-layers
        (list
                (make pml
                        (thickness 2.0)
                )
        )
)

(set! resolution 20)

(run-until 50
        (at-beginning output-epsilon)
        (at-end output-efield-x)
        (at-end output-efield-y)
        (at-end output-efield-z)
)

