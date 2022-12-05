(defpackage aoc-2022/tests/4
  (:use :cl
        :rove))
(in-package :aoc-2022/tests/4)

(deftest day-4
  (let ((day (make-instance 'aoc-2022.4:day-4)))
    (testing "sample-1"
             (ok (eq (aoc-2022.4:run-sample-1 day)
                     2)))
    (testing "sample-2"
             (ok (eq (aoc-2022.4:run-sample-2 day)
                     4)))))
