module Flow = struct
  type sink' = Eio.Flow.sink_ty Eio.Flow.sink

  let cast_sink (a : _ Eio.Flow.sink) : sink' = (a :> sink')
end

module Path = struct
  type t' = Eio.Fs.dir_ty Eio.Path.t

  let cast (a : _ Eio.Path.t) : t' = (a :> t')
  let basename t = Option.map snd (Eio.Path.split t)
  let dirname t = Option.map fst (Eio.Path.split t)
end

module Process = struct
  type mgr' = [ `Generic ] Eio.Process.mgr_ty Eio.Process.mgr

  let cast_mgr (a : _ Eio.Process.mgr) : mgr' = (a :> mgr')
end
