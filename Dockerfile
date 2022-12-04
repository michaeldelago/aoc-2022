FROM fukamachi/sbcl as build
WORKDIR /app
COPY Makefile Makefile
COPY aoc-2022.asd aoc-2022.asd
COPY src src
RUN --mount=type=cache,target=/root/.cache/common-lisp make

FROM scratch
WORKDIR /app
COPY --from=build /app/build/aoc-2022 aoc-2022
COPY inputs inputs
ENTRYPOINT ["/app/aoc-2022"]
