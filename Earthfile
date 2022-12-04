VERSION 0.6
FROM fukamachi/sbcl

build:
    WORKDIR /app
    COPY Makefile Makefile
    COPY aoc-2022.asd aoc-2022.asd
    COPY src src
    RUN --mount=type=cache,target=/root/.cache/common-lisp make
    
    SAVE ARTIFACT build/aoc-2022 AS LOCAL aoc-2022
