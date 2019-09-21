library(igraph)
init.igraph <- function(data,dir=F,rem.multi=T){
  labels <- union(unique(data[,1]),unique(data[,2]))
  ids <- 1:length(labels);names(ids) <- labels
  from <- as.character(data[,1]);to <- as.character(data[,2])
  edges <- matrix(c(ids[from],ids[to]),nc = 2)
  g <- graph.empty(directed = dir)
  g <- add.vertices(g,length(labels))
  V(g)$label = labels
  g <- add.edges(g,t(edges))
  if(rem.multi){
    E(g)$weight <-count.multiple(g)
    g <- simplify(g, remove.multiple= TRUE , remove.loops = TRUE,edge.attr.comb = 'mean')
  }
  g
}
  