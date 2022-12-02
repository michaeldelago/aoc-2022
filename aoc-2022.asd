(defsystem "aoc-2022"
  :version "0.1.0"
  :author "Mike Delago"
  :license "WTFPL"
  :depends-on ("alexandria"
               "cl-cookie"
               "cl-ppcre"
               "dexador"
               "uiop"
               "unix-opts")
  :components ((:module "src"
                :components
                ((:file "get-input")
                 (:file "1")
                 (:file "cli"))))
  :description "Advent of Code 2022"
  :in-order-to ((test-op (test-op "aoc-2022/tests")))
  :build-operation "program-op"
  :build-pathname "build/aoc-2022"
  :entry-point "aoc-2022.cli:main")

(defsystem "aoc-2022/tests"
  :author "Mike Delago"
  :license "WTFPL"
  :depends-on ("aoc-2022"
               "rove")
  :components ((:module "tests"
                :components
                ((:file "main"))))
  :description "Test system for aoc-2022"
  :perform (test-op (op c) (symbol-call :rove :run c)))
