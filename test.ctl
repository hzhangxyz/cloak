(define l 0.5)

(define d (vector3 2 0 0))

(define s 3)

(define sig 1)

(set! geometry-lattice
        (make lattice
                (size 20 20 no-size)
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
                        (center 0 0)
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
        (at-end output-efield-z)
        (at-end output-efield-y)
        (at-end output-efield-x)
)

