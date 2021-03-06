spark_worker_apply <- function(sc) {
  hostContextId <- invoke_method(sc, FALSE, "Handler", "getHostContext")
  log("retrieved worker context id ", hostContextId)

  context <- structure(
    class = c("spark_jobj", "worker_jobj"),
    list(
      id = hostContextId,
      connection = sc
    )
  )

  log("retrieved worker context")

  length <- worker_invoke(context, "getSourceArrayLength")
  log("found ", length, " rows")

  data <- worker_invoke(context, "getSourceArraySeq")
  log("retrieved ", length(data), " rows")

  closureRaw <- worker_invoke(context, "getClosure")
  closure <- unserialize(closureRaw)

  columnNames <- worker_invoke(context, "getColumns")

  data <- lapply(data, function(e) {
    names(e) <- columnNames
    e
  })

  data <- if (length(formals(closure)) > 0)
    lapply(data, closure)
  else
    lapply(data, function(e) {
      closure()
    })

  if (!identical(typeof(data[[1]]), "list")) {
    data <- lapply(data, function(e) list(e))
  }

  worker_invoke(context, "setResultArraySeq", data)
  log("updated ", length(data), " rows")

  spark_split <- worker_invoke(context, "finish")
  log("finished apply")
}

spark_worker_collect <- function(sc) {
  collected <- invoke_static(sc, "sparklyr.Utils", "collect", sdf, separator$regexp)

  transformed <- lapply(collected, function(e) {
    sdf_deserialize_column(e, sc)
  })
}
