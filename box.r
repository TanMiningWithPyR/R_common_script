#此脚本是用来配合画图的
#画图字体，设置时用family= "YH"
windowsFonts( YH=windowsFont("微软雅黑"),
              XW=windowsFont("华文新魏"),
              YY=windowsFont("幼圆"))

#分组箱线图的数值，返回一个列表，包含了n是有多少个组，对应组的离群值(observation)

box_stat_groupby <- function(data_frame,x,by){
  group <- unique(data_frame[by])[,1]
  group_list <- list(n = length(group))
  for (i in group) {
    a <- data_frame[which(data_frame[by] == i),]
    box_x <- a[x][,1]
    box_stats <- boxplot.stats(box_x)
    out_data <- data_frame[data_frame[x][,1] %in%  box_stats$out,]
    group_list[[i]] <- out_data
  }
  return(group_list)
}

