(** Exploring potential additions to [Eio]'s api.

    {1 Casting}

    As explained here https://github.com/ocaml-multicore/eio#casting if you want
    to store a value of a parametrized eio type, this may require you to cast
    internally. The concrete type you need to cast to is not always obvious, so
    this module proposes to introduce some type aliases to make casting easier.

    The current convention is to add a ['] suffix to the type alias name.

    For example:

    {[
      type Eio.Process.mgr' = [ `Generic ] Eio.Process.mgr_ty Eio.Process.mgr
    ]}

    The idea is that in the user land, when you need to cast, you would only
    refer to the ['] type alias, and not have to make the parameter appear
    explicitly.

    It is not clear to me which style is to be preferred between casting at call
    site using ':>' or using a function call to cast, so for now I included
    [cast_] functions as well.

    For example:

    {[
      val Eio.Process.cast_mgr : _ Eio.Process.mgr -> Eio.Process.mgr'
    ]} *)

module Buf_write : sig
  type t := Eio.Buf_write.t

  (** Adding a [printf] function to [Eio.Buf_write] to make it easier to write
      from format strings. *)

  val printf : t -> ('a, unit, string, unit) format4 -> 'a
  val aprintf : t -> ('a, Stdlib.Format.formatter, unit) format -> 'a
end

module Flow : sig
  (** {2 Casting} *)

  type sink' = Eio.Flow.sink_ty Eio.Flow.sink

  val cast_sink : _ Eio.Flow.sink -> sink'
end

module Path : sig
  (** {2 Casting} *)

  type t' = Eio.Fs.dir_ty Eio.Path.t

  val cast : _ Eio.Path.t -> t'

  (** {2 Path manipulation}

      Exploring adding unix-like path manipulation functions to [Eio.Path]. *)

  val basename : _ Eio.Path.t -> string option
  val dirname : 'a Eio.Path.t -> 'a Eio.Path.t option
end

module Process : sig
  (** {2 Casting} *)

  type mgr' = [ `Generic ] Eio.Process.mgr_ty Eio.Process.mgr

  val cast_mgr : _ Eio.Process.mgr -> mgr'
end
