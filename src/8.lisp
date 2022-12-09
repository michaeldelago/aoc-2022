(uiop:define-package aoc-2022.8
  (:use :cl
   :aoc-2022.day)
  (:import-from :cl-ppcre
   #:all-matches-as-strings)
  (:export #:day-8
   #:run
   #:run-sample-1
   #:run-sample-2))
(in-package :aoc-2022.8)


(defclass day-8 (day)
  ((day
     :initform 8)))

(defun run (&optional sample)
  (let ((day (make-instance 'day-8)))
    (if sample
        (do-run-sample day)
        (do-run day))))

(defmethod part-1 ((this day-8) input)
  (let ((grid (make-grid (uiop:split-string input :separator '(#\NEWLINE)))))
    (count t (mapcar #'tree-is-visible grid (loop repeat (length input) collect grid)))))

(defmethod part-2 ((this day-8) input)
  (let* ((grid (make-grid (uiop:split-string input :separator '(#\NEWLINE)))))
    (reduce #'max (mapcar (lambda (tree)
                   (scenic-score tree grid)) grid))))


(defun make-grid (input)
  (let* ((len-grid (length (car input)))
         (as-ints (mapcar (lambda (l)
                            (map 'list #'digit-char-p l)) input))
         (heights (alexandria:flatten as-ints)))
    (loop for hght in heights
          for index from 0
          for x = (mod index len-grid)
          for y = (floor index len-grid)
          collect (cons (list x y) hght))))

(defun tree-is-visible (tree grid)
  (flet ((tree-visible (other-tree)
           (> (cdr tree) (alexandria:assoc-value grid other-tree))))
    (or (tree-on-edge tree grid)
        (some (lambda (x) x) (mapcar (lambda (direction)
                                       (every #'tree-visible direction)) 
                                     (get-neighbors (car tree) grid))))))

(defun scenic-score (tree grid)
  (let ((height (cdr tree)))
    (destructuring-bind (left right down up)
        (get-neighbors (car tree) grid)
      (flet ((dist-until-block (direction)
               (if (tree-on-edge tree grid)
                   0
                   (loop for o-tree in direction
                         for dist from 1
                         if (<= height (alexandria:assoc-value grid o-tree))
                         return dist
                         finally (return dist))) ))
        (* (dist-until-block (nreverse left) )
           (dist-until-block (nreverse up))
           (dist-until-block right)
           (dist-until-block down))))))

(defun tree-on-edge (tree grid)
  (let* ((y (cadar tree))
         (x (caar tree))
         (max-x (reduce #'max (loop for coord in grid collect (caar coord))))
         (max-y (reduce #'max (loop for coord in grid collect (cadar coord)))))
    (or (eq x 0) 
        (eq y 0) 
        (eq x max-x) 
        (eq y max-y))))

(defun get-neighbors (tree-coord tree-grid)
  (let* ((x (car tree-coord))
         (y (cadr tree-coord))
         (all-neighbors (loop for coord in tree-grid
                              for this-x = (caar coord)
                              for this-y = (cadar coord)
                              if (or (eq this-x x) (eq this-y y))
                              collect (car coord))))
    (list
      (loop for coord in all-neighbors ;; left
            for this-x = (car coord)
            for this-y = (cadr coord)
            if (and (< this-x x) (eq this-y y))
            collect coord)
      (loop for coord in all-neighbors ;; right
            for this-x = (car coord)
            for this-y = (cadr coord)
            if (and (> this-x x) (eq this-y y))
            collect coord)
      (loop for coord in all-neighbors ;; up 
            for this-x = (car coord)
            for this-y = (cadr coord)
            if (and (eq this-x x) (> this-y y))
            collect coord)
      (loop for coord in all-neighbors ;; down
            for this-x = (car coord)
            for this-y = (cadr coord)
            if (and (eq this-x x) (< this-y y))
            collect coord))))

