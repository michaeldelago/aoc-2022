(uiop:define-package aoc-2022.2
  (:use :cl
        :aoc-2022.day)
  (:export #:day-2
           #:run
           #:run-sample-1
           #:run-sample-2))
(in-package :aoc-2022.2)


(defparameter *match* '(("A" . ROCK)
                        ("B" . PAPER)
                        ("C" . SCISSORS)
                        ("X" . ROCK)
                        ("Y" . PAPER)
                        ("Z" . SCISSORS)))

(defparameter *match-2* '(("X" . LOSE)
                          ("Y" . DRAW)
                          ("Z" . WIN)))

(defparameter *point-value* '((PAPER . 2)
                              (ROCK . 1)
                              (SCISSORS . 3)))

(defday 2)

(defmethod part-1 ((this day-2) input)
  (let ((splits (split-input input)))
    (reduce #'+
            (mapcar #'run-game-1 splits))))

(defmethod part-2 ((this day-2) input)
  (let ((splits (split-input input)))
    (reduce #'+
            (mapcar #'run-game-2 splits))))


(defun split-input (input)
  (let* ((lines-input (cl-ppcre:split "\\n" input))
         (many-splits (loop repeat (length lines-input) collect "\\s")))
    (mapcar #'cl-ppcre:split many-splits lines-input)))

;; Feed a game and receive the score from that game
;; Calculate score under the assumption that the second item in list is a move
; (run-game-1 (list "A" "Y")) => 8
; (run-game-1 (list "B" "X")) => 1
; (run-game-1 (list "C" "Z")) => 6
(defun run-game-1 (game)
  (let ((opponent (alexandria:assoc-value *match* (car game) :test #'equal))
        (me (alexandria:assoc-value *match* (cadr game) :test #'equal)))
    (+ (alexandria:assoc-value *point-value* me)  
       (cond
         ((eq opponent me) 3) ;; draw
         ((or (and (eq opponent 'ROCK)    (eq me 'SCISSORS)) ;; lose
              (and (eq opponent 'PAPER)   (eq me 'ROCK))
              (and (eq opponent 'SCISSORS)(eq me 'PAPER))) 0)
         (t 6))))) ;; win

;; Feed a game and receive the score from that game
;; Calculate score under the assumption that the second item in list is an outcome
; (run-game-1 (list "A" "Y")) => 4
; (run-game-1 (list "B" "X")) => 1
; (run-game-1 (list "C" "Z")) => 7
(defun run-game-2 (game)
  (let ((opponent (alexandria:assoc-value *match* (car game) :test #'equal))
        (outcome (alexandria:assoc-value *match-2* (cadr game) :test #'equal)))
    (cond
      ((eq outcome 'DRAW) (run-game-1 (list (car game) (car game))))
      ((eq outcome 'LOSE)
       (cond 
         ((eq opponent 'ROCK)     (run-game-1 (list (car game) "C")))
         ((eq opponent 'PAPER)    (run-game-1 (list (car game) "A")))
         ((eq opponent 'SCISSORS) (run-game-1 (list (car game) "B")))))
      ((eq outcome 'WIN)
       (cond
         ((eq opponent 'ROCK)     (run-game-1 (list (car game) "B")))
         ((eq opponent 'PAPER)    (run-game-1 (list (car game) "C")))
         ((eq opponent 'SCISSORS) (run-game-1 (list (car game) "A"))))))))

