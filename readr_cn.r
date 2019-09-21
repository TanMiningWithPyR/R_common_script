#readr_cn project

chinese <- locale(date_format = "%m/%d/%Y",time_format = "%H:%M",tz = "Asia/Taipei",encoding = "cp936")

read_csv_cn <- function(file, col_names = TRUE, col_types = NULL,locale = chinese,
                        na = c("", "NA","N/A"), comment = "",
                        trim_ws = TRUE, skip = 0, n_max = -1, progress = interactive()){
  read_csv(file = file, col_names = col_names, col_types = col_types,locale = locale, na = na, comment = comment,
           trim_ws = trim_ws, skip = skip, n_max = n_max, progress = progress)
}