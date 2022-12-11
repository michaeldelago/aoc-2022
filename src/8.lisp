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

(defday 8)

(defmethod part-1 ((this day-8) input)
	(let* ((grid (make-grid (uiop:split-string input :separator '(#\NEWLINE))))
				 (max-x (reduce #'max 
												(loop for coord being the hash-keys of grid
															collect (car coord))))
				 (max-y (reduce #'max 
												(loop for coord being the hash-keys of grid
															collect (cadr coord)))))
		(count t (loop for tree being the hash-keys of grid
									 collect (tree-is-visible 
														 (cons tree (gethash tree grid)) grid (list max-x max-y))))))

(defmethod part-2 ((this day-8) input)
	(let* ((grid (make-grid (uiop:split-string input :separator '(#\NEWLINE))))
				 (max-x (reduce #'max 
												(loop for coord being the hash-keys of grid
															collect (car coord))))
				 (max-y (reduce #'max 
												(loop for coord being the hash-keys of grid
															collect (cadr coord)))))
		(reduce #'max (loop for tree being the hash-keys of grid
												collect (scenic-score 
																	(cons tree (gethash tree grid))	grid (list max-x max-y))))))

;; turn a single string grid into a alist
(defun make-grid (input)
	(let* ((len-grid (length (car input)))
				 (as-ints (mapcar (lambda (l)
														(map 'list #'digit-char-p l)) input))
				 (heights (alexandria:flatten as-ints)))
		(loop with hash = (make-hash-table :test #'equalp)
					for hght in heights
					for index from 0
					for x = (mod index len-grid)
					for y = (floor index len-grid)
					do (setf (gethash (list x y) hash) hght)
					finally (return hash))))

;; return true if tree is visible from the outside
(defun tree-is-visible (tree grid limits)
	(flet ((tree-visible (other-tree)
					 (> (cdr tree) (gethash other-tree grid))))
		(or (tree-on-edge tree limits)
				(some (lambda (x) x) 
							(mapcar (lambda (direction)
												(every #'tree-visible direction)) 
											(get-neighbors (car tree) limits))))))


;; get the scenic score for a tree
(defun scenic-score (tree grid limits)
	(destructuring-bind (left right up down)
			(get-neighbors (car tree) limits)
		(* (dist-until-block left tree grid limits)
			 (dist-until-block right tree grid limits)
			 (dist-until-block up tree grid limits)
			 (dist-until-block down tree grid limits))))

(defun tree-on-edge (tree limits)
	(let* ((y (cadar tree))
				 (x (caar tree))
				 (max-x (car limits))
				 (max-y (cadr limits)))
		(or (eq x 0) 
				(eq y 0) 
				(eq x max-x) 
				(eq y max-y))))

;; Get all coordinates of trees in each cardinal direction
(defun get-neighbors (tree-coord limits)
	(let* ((x (car tree-coord))
				 (y (cadr tree-coord))
				 (max-x (car limits))
				 (max-y (cadr limits)))
		(list
			(if (> x 0)
					(loop for this-x downfrom (1- x) to 0 ;; left
								collect (list this-x y))
					(list)) 
			(if (< x max-x)
					(loop for this-x from (1+ x) to max-x ;; right
								collect (list this-x y))
					(list)) 
			(if (> y 0)
					(loop for this-y downfrom (1- y) to 0 ;; up 
								collect (list x this-y))
					(list)) 
			(if (< y max-y)
					(loop for this-y from (1+ y) to max-y ;; down
								collect (list x this-y))
					(list)))))

;; Get the distance from a tree in a direction until blocked
;; the direction is a list of coordinates between the tree and the edge
(defun dist-until-block (direction tree grid limits)
	(if (tree-on-edge tree limits)
			0
			(loop for o-tree in direction
						for dist from 1
						if (<= (cdr tree) (gethash o-tree grid))
						return dist
						finally (return dist))))
