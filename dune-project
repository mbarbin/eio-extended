(lang dune 3.12)

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
    (>= v0.16)
    (< v0.17)))
  (eio
   (>= 0.13))
  (eio_main
   (and
    :with-test
    (>= 0.13)))
  (expect_test_helpers_core
   (and
    :with-test
    (>= v0.16)
    (< v0.17)))
  (ppx_jane
   (and
    (>= v0.16)
    (< v0.17)))
  (ppx_js_style
   (and
    (>= v0.16)
    (< v0.17)))))
