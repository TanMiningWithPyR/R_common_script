library(stringr)
library(XML)
library(readr)
library(plyr)
library(dplyr)

pinyin_city <- read_csv("pinyin_weather.csv")

#pinyin_city <- pinyin_city %>% filter(en_name1 == "bengbu" | en_name1 == "dongguan" | en_name1 =="luan" | en_name1 =="luoyang")

root_url <- "http://www.tianqihoubao.com/lishi"
city <- pinyin_city$en_name2
month_str <- c(str_c("0",1:9,sep = ""),"10","11","12")
month <- c(str_c("2015",month_str,".html",sep = ""),str_c("2016",month_str,".html",sep = ""))
paste_city_month <- function(city){
  str_c(str_c(c(root_url,city,"month/"),collapse = "/"),month,sep = "")
}
city_permonth_url_list <- lapply(city,paste_city_month)
names(city_permonth_url_list) <- city

weather_function <- function(city_permonth_url){
  city_yearmonth <- htmlParse(city_permonth_url,encoding = "gb2312")
  city_yearmonth_table <- readHTMLTable(city_yearmonth)[[1]]
  names(city_yearmonth_table) <- c("date","status","temp","wind_direction_force")
  a <- city_yearmonth_table %>% separate(col = status,into = c("first_status","second_status"),sep = "/") %>%
    separate(col = temp,into = c("highest_temp","lowest_temp"),sep = "/") %>%
    separate(col = wind_direction_force,into = c("first_wind","second_wind"),sep = "/") %>%
    separate(col = first_wind,into = c("first_wind_direction","first_wind_force"),sep = " ") %>%
    separate(col = second_wind,into = c("second_wind_direction","second_wind_force"),sep = " ")
  a$date <- as.Date(a$date,"%Y年%m月%d日")
  a$highest_temp <- as.integer(str_trim(str_replace(a$highest_temp,"℃\r\n","")))
  a$lowest_temp <- as.integer(str_trim(str_replace(a$lowest_temp,"℃","")))
  
  return(a)
}

weather_function <- function(city_permonth_url){
  city_yearmonth <- htmlParse(city_permonth_url,encoding = "gb2312")
  city_yearmonth_table <- readHTMLTable(city_yearmonth)[[1]]
  return(city_yearmonth_table)
}

weather_df_list=list()
for (i in names(city_permonth_url_list)){
  weather_df_list[[i]] <- lapply(city_permonth_url_list[[i]],weather_function)
  city_weather <- bind_rows(weather_df_list[[i]])
  file_name = str_c(i,".csv")
  print(file_name)
  write_csv(city_weather,file_name)
}



