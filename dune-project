(lang dune 3.15)

(name eio-extended)

(generate_opam_files)

(license MIT)

(authors "Mathieu Barbin")

(maintainers "Mathieu Barbin")

(source
 (github mbarbin/eio-extended))

(documentation "https://mbarbin.github.io/eio-extended/")

(package
 (name eio-extended)
 (synopsis "Experimenting with a few additions to Eio's api")
 (depends
  (ocaml
   (>= 5.1))
  (base
   (and
    :with-test
    (>= v0.17)
    (< v0.18)))
  (eio
   (>= 1.0))
  (eio_main
   (and
    :with-test
    (>= 1.0)))
  (expect-test-helpers
   (and
    :with-test
    (>= v0.17)
    (< v0.18)))
  (ppx_compare
   (and
    (>= v0.17)
    (< v0.18)))
  (ppx_enumerate
   (and
    (>= v0.17)
    (< v0.18)))
  (ppx_expect
   (and
    :with-test
    (>= v0.17)
    (< v0.18)))
  (ppx_hash
   (and
    (>= v0.17)
    (< v0.18)))
  (ppx_here
   (and
    (>= v0.17)
    (< v0.18)))
  (ppx_js_style
   (and
    :dev
    (>= v0.17)
    (< v0.18)))
  (ppx_let
   (and
    (>= v0.17)
    (< v0.18)))
  (ppx_sexp_conv
   (and
    (>= v0.17)
    (< v0.18)))
  (ppx_sexp_value
   (and
    (>= v0.17)
    (< v0.18)))))
