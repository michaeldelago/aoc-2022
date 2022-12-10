(defpackage aoc-2022/tests/10
  (:use :cl
        :rove))
(in-package :aoc-2022/tests/10)

(deftest day-10
  (let ((day (make-instance 'aoc-2022.10:day-10)))
    (testing "sample-1"
             (ok (equal (aoc-2022.10:run-sample-1 day)
                        13140)))
    (testing "sample-2"
             (ok (equalp (aoc-2022.10:run-sample-2 day)
                        "
##..##..##..##..##..##..##..##..##..##..
###...###...###...###...###...###...###.
####....####....####....####....####....
#####.....#####.....#####.....#####.....
######......######......######......####
#######.......#######.......#######.....")))))