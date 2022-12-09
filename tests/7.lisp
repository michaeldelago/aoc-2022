(defpackage aoc-2022/tests/7
  (:use :cl
        :rove))
(in-package :aoc-2022/tests/7)

(deftest day-7
  (let ((day (make-instance 'aoc-2022.7:day-7)))
    (testing "sample-1"
             (ok (equal (aoc-2022.7:run-sample-1 day)
                        95437)))
    (testing "sample-2"
             (ok (equal (aoc-2022.7:run-sample-2 day)
                        24933642)))))
