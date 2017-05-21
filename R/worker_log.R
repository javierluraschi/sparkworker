log_format <- function(message, level = "INFO") {
  paste(format(Sys.time(), "%y/%m/%d %H:%M:%S"), level, "sparklyr-rworker:", message)
}

log_level <- function(..., level) {
  args = list(...)
  message <- paste(args, sep = "", collapse = "")
  formatted <- log_format(message, level)
  cat(formatted, "\n")
}

log <- function(...) {
  log_level(..., level = "INFO")
}

log_warning<- function(...) {
  log_level(..., level = "WARN")
}

log_error <- function(...) {
  log_level(..., level = "ERROR")
}

unlockBinding("stop",  as.environment("package:base"))
assign("stop", function(...) {
  log_error(...)
  quit()
}, as.environment("package:base"))
lockBinding("stop",  as.environment("package:base"))