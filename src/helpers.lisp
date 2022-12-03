(uiop:define-package aoc-2022.helpers
  (:use :cl)
  (:export #:split-newlines))
(in-package :aoc-2022.helpers)

(defun split-newlines (input)
  "Split a string on newlines"
  (cl-ppcre:split "\\n" input))
