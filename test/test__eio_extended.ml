module Value = struct
  type t = Value of int

  let pp fmt (Value v) = Stdlib.Format.fprintf fmt "value:%d" v
end

let%expect_test "Buf_write.printf" =
  Eio_main.run
  @@ fun env ->
  Eio.Buf_write.with_flow (Eio.Stdenv.stdout env)
  @@ fun w ->
  Eio_extended.Buf_write.printf w "Hello, %s\n" "World!";
  Eio.Buf_write.flush w;
  [%expect {| Hello, World! |}];
  Eio_extended.Buf_write.aprintf w "Hello Value %a\n" Value.pp (Value 42);
  Eio.Buf_write.flush w;
  [%expect {| Hello Value value:42 |}];
  ()
;;

module With_casting : sig
  type t

  val create : env:< stdout : _ Eio.Flow.sink ; .. > -> t
  val print_endline : t -> string -> unit
end = struct
  type t = { stdout : Eio_extended.Flow.sink' }

  let create ~env = { stdout = Eio_extended.Flow.cast_sink (Eio.Stdenv.stdout env) }

  (* Casting with ':>' is possible too, maybe all we need is the type alias, TBD. *)
  let _create' ~env : t = { stdout = (Eio.Stdenv.stdout env :> Eio_extended.Flow.sink') }

  let print_endline t str =
    Eio.Buf_write.with_flow t.stdout
    @@ fun w -> Eio_extended.Buf_write.printf w "%s\n" str
  ;;
end

let%expect_test "With_casting" =
  Eio_main.run
  @@ fun env ->
  let t = With_casting.create ~env in
  With_casting.print_endline t "Hello, World!";
  [%expect {| Hello, World! |}];
  ()
;;

let%expect_test "components" =
  Eio_main.run
  @@ fun env ->
  let cwd = Eio.Stdenv.cwd env in
  let test path =
    let path = Eio.Path.(cwd / path) in
    let fpath =
      match path |> snd |> Fpath.of_string with
      | Error (`Msg msg) -> [%sexp (msg : string)]
      | Ok path ->
        [%sexp
          { path = (Fpath.to_string path : string)
          ; segments = (Fpath.segs path : string list)
          ; parent = (Fpath.parent path |> Fpath.to_string : string)
          ; filename = (Fpath.filename path : string)
          }]
    in
    print_s
      [%sexp
        { fpath : Sexp.t
        ; path = (path |> snd : string)
        ; dirname = (Eio_extended.Path.dirname path |> Option.map ~f:snd : string option)
        ; basename = (Eio_extended.Path.basename path : string option)
        }]
  in
  test "";
  [%expect
    {|
    ((fpath "\"\": invalid path")
     (path  "")
     (dirname  ())
     (basename ())) |}];
  test ".";
  [%expect
    {|
    ((fpath (
       (path .)
       (segments (.))
       (parent   ./../)
       (filename "")))
     (path .)
     (dirname  (""))
     (basename (.))) |}];
  test "./.";
  [%expect
    {|
    ((fpath (
       (path ./.)
       (segments (. .))
       (parent   ././../)
       (filename "")))
     (path ./.)
     (dirname  (.))
     (basename (.))) |}];
  test "./";
  [%expect
    {|
    ((fpath (
       (path ./)
       (segments (. ""))
       (parent   ./../)
       (filename "")))
     (path ./)
     (dirname  (""))
     (basename (.))) |}];
  test "./.foo";
  [%expect
    {|
    ((fpath (
       (path ./.foo)
       (segments (. .foo))
       (parent   ./)
       (filename .foo)))
     (path ./.foo)
     (dirname  (.))
     (basename (.foo))) |}];
  test ".foo";
  [%expect
    {|
    ((fpath (
       (path .foo)
       (segments (.foo))
       (parent   ./)
       (filename .foo)))
     (path .foo)
     (dirname  (""))
     (basename (.foo))) |}];
  test "/";
  [%expect
    {|
    ((fpath (
       (path /)
       (segments ("" ""))
       (parent   /)
       (filename "")))
     (path /)
     (dirname  ())
     (basename ())) |}];
  test "/bar";
  [%expect
    {|
    ((fpath (
       (path /bar)
       (segments ("" bar))
       (parent   /)
       (filename bar)))
     (path /bar)
     (dirname  (/))
     (basename (bar))) |}];
  test "foo/bar";
  [%expect
    {|
    ((fpath (
       (path foo/bar)
       (segments (foo bar))
       (parent   foo/)
       (filename bar)))
     (path foo/bar)
     (dirname  (foo))
     (basename (bar))) |}];
  test "/foo/bar";
  [%expect
    {|
    ((fpath (
       (path /foo/bar)
       (segments ("" foo bar))
       (parent   /foo/)
       (filename bar)))
     (path /foo/bar)
     (dirname  (/foo))
     (basename (bar))) |}];
  test "/foo/bar/baz";
  [%expect
    {|
    ((fpath (
       (path /foo/bar/baz)
       (segments ("" foo bar baz))
       (parent   /foo/bar/)
       (filename baz)))
     (path /foo/bar/baz)
     (dirname  (/foo/bar))
     (basename (baz))) |}];
  test "/foo/bar//baz/";
  [%expect
    {|
    ((fpath (
       (path /foo/bar/baz/)
       (segments ("" foo bar baz ""))
       (parent   /foo/bar/)
       (filename "")))
     (path /foo/bar//baz/)
     (dirname  (/foo/bar))
     (basename (baz))) |}];
  test "bar";
  [%expect
    {|
    ((fpath (
       (path bar)
       (segments (bar))
       (parent   ./)
       (filename bar)))
     (path bar)
     (dirname  (""))
     (basename (bar))) |}];
  test "./foo/bar";
  [%expect
    {|
       ((fpath (
          (path ./foo/bar)
          (segments (. foo bar))
          (parent   ./foo/)
          (filename bar)))
        (path ./foo/bar)
        (dirname  (./foo))
        (basename (bar))) |}];
  ()
;;
