(defpackage aoc-2022/tests/main
  (:use :cl
        :rove))
(in-package :aoc-2022/tests/main)

(deftest day-1
  (let ((day (make-instance 'aoc-2022.1:day-1)))
   (testing "sample-1"
           (ok (eq (aoc-2022.1:run-sample-1 day)
                   24000)))
   (testing "sample-2"
           (ok (eq (aoc-2022.1:run-sample-2 day)
                   45000)))))

(deftest day-2
  (let ((day (make-instance 'aoc-2022.2:day-2)))
   (testing "sample-1"
           (ok (eq (aoc-2022.2:run-sample-1 day)
                   15)))
   (testing "sample-2"
           (ok (eq (aoc-2022.2:run-sample-2 day)
                   12)))))

(deftest day-3
  (let ((day (make-instance 'aoc-2022.3:day-3)))
   (testing "sample-1"
           (ok (eq (aoc-2022.3:run-sample-1 day)
                   157)))
   (testing "sample-2"
           (ok (eq (aoc-2022.3:run-sample-2 day)
                   70)))))

(deftest day-4
  (let ((day (make-instance 'aoc-2022.4:day-4)))
    (testing "sample-1"
             (ok (eq (aoc-2022.4:run-sample-1 day)
                     2)))
    (testing "sample-2"
             (ok (eq (aoc-2022.4:run-sample-2 day)
                     4)))))
