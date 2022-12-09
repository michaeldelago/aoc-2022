(defpackage aoc-2022/tests/8
  (:use :cl
        :rove))
(in-package :aoc-2022/tests/8)

(deftest day-8
  (let ((day (make-instance 'aoc-2022.8:day-8)))
    (testing "sample-1"
             (ok (equal (aoc-2022.8:run-sample-1 day)
                        21)))
    (testing "sample-2"
             (ok (equal (aoc-2022.8:run-sample-2 day)
                        8)))))
