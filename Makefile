LISP?=sbcl

test:
	$(LISP) \
		--non-interactive \
		--load aoc-2022.asd \
		--eval '(asdf:test-system :aoc-2022)' \

build:
	$(LISP) \
		--non-interactive \
		--load aoc-2022.asd \
		--eval '(ql:quickload :aoc-2022)' \
		--eval '(asdf:make :aoc-2022 :force t)' \
		
