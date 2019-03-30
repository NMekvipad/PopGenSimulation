library("RColorBrewer")

stairway_plot <- function(dataset_name, plot_title, xlim=c(0, 250000), ylim=c(1000,15000)){
  files <- list.files(pattern = dataset_name)
  col_palette = brewer.pal(n = length(files), name = 'Set1')
  count = 1
  newplot = TRUE
  for (afile in files) {
    stairway_raw = read.table(afile, sep = '\t', header=TRUE)
    stairway_xy = stairway_raw[,6:7]
    stairway_xy[,1] = stairway_xy[,1]/1000
    if(newplot){
      plot(stairway_xy[,1], stairway_xy[,2], col=col_palette[count], type='l', 
           lwd=1.5, xlab = 'Years (kyr)', ylab = 'Effective population size',
           main = plot_title, xlim = xlim, ylim = ylim)
      newplot = FALSE
    }
    else{
      lines(stairway_xy[,1], stairway_xy[,2], col=col_palette[count], lwd=1.5)
    }
    count = count + 1
  }
  
}

sfs_plot <- function(dataset_name, plot_title, ylim=c(0, 1)){
  files <- list.files(pattern = dataset_name)
  col_palette = brewer.pal(n = length(files), name = 'Set1')
  first_row = TRUE
  
  for (afile in files) {
    sfs_raw = read.table(afile, sep = '\t', skip = 2, header = FALSE)[,1:10]
    sfs_normalized = sfs_raw[ ,2:ncol(sfs_raw)] / rowSums(sfs_raw[ ,2:ncol(sfs_raw)])
    mean_sfs = colMeans(sfs_normalized)
    
    if(first_row){
      sfs_df = mean_sfs
      first_row = FALSE
    }
    else{
      sfs_df = rbind(sfs_df, mean_sfs)
    }
  }
  colnames(sfs_df) <- 1:(ncol(sfs_df))
  barplot(sfs_df, col=col_palette, border="black", beside=TRUE, 
          xlab="Frequency", ylab="Proportion of SNPs", ylim = ylim, main = plot_title)
  
}












