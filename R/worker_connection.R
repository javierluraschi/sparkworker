connection_is_open <- function(sc) {
  bothOpen <- FALSE
  if (!identical(sc, NULL)) {
    tryCatch({
      bothOpen <- isOpen(sc$backend) && isOpen(sc$monitor)
    }, error = function(e) {
    })
  }
  bothOpen
}

worker_connection <- function(x, ...) {
  UseMethod("worker_connection")
}

worker_connection.spark_jobj <- function(x, ...) {
  x$connection
}
