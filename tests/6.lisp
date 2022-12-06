(defpackage aoc-2022/tests/6
  (:use :cl
        :rove))
(in-package :aoc-2022/tests/6)

(deftest day-6
  (let ((day (make-instance 'aoc-2022.6:day-6)))
    (testing "sample-1"
             (ok (equal (aoc-2022.6:run-sample-1 day)
                        7)))
    (testing "sample-2"
             (ok (equal (aoc-2022.6:run-sample-2 day)
                         19)))))
