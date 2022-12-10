(defpackage aoc-2022/tests/9
  (:use :cl
        :rove))
(in-package :aoc-2022/tests/9)

(deftest day-9
  (let ((day (make-instance 'aoc-2022.9:day-9)))
    (testing "sample-1"
             (ok (equal (aoc-2022.9:run-sample-1 day)
                        13)))
    (testing "sample-2"
             (ok (equal (aoc-2022.9:run-sample-2 day "large")
                        36)))))
