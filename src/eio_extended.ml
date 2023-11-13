module Buf_write = struct
  let printf t fmt = Printf.ksprintf (fun str -> Eio.Buf_write.string t str) fmt
  let aprintf t fmt = Format.kasprintf (fun str -> Eio.Buf_write.string t str) fmt
end

module Flow = struct
  type sink' = Eio.Flow.sink_ty Eio.Flow.sink

  let cast_sink (a : _ Eio.Flow.sink) : sink' = (a :> sink')
end

module Path = struct
  type t' = Eio.Fs.dir_ty Eio.Path.t

  let cast (a : _ Eio.Path.t) : t' = (a :> t')

  let components t =
    if String.equal (snd t) ""
    then [ "." ]
    else (
      let is_absolute =
        let path = t |> snd in
        String.length path > 0 && Char.equal path.[0] '/'
      in
      let rec aux acc t =
        match Eio.Path.split t with
        | None -> if is_absolute then "" :: acc else acc
        | Some (t, component) -> aux (component :: acc) t
      in
      aux [] t)
  ;;

  let basename t =
    match Eio.Path.split t with
    | Some (_, p) -> p
    | None ->
      (match t |> snd with
       | ("" | "/") as p -> p
       | _ -> failwith "Eio.Path.basename: invalid path")
  ;;

  let dirname t =
    match Eio.Path.split t with
    | Some ((_, dir), _) ->
      let len = String.length dir in
      if len = 0 then "." else dir
    | None ->
      (match t |> snd with
       | "" -> "."
       | "/" -> "/"
       | _ -> failwith "Eio.Path.dirname: invalid path")
  ;;

  let parent_dir ((root, _) as t) = root, dirname t
end

module Process = struct
  type mgr' = [ `Generic ] Eio.Process.mgr_ty Eio.Process.mgr

  let cast_mgr (a : _ Eio.Process.mgr) : mgr' = (a :> mgr')
end
