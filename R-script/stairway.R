library("RColorBrewer")

##########################       TEST AREA       ##########################

setwd("~/Desktop/pop_gen/project/stairway_R")
stairway_raw = read.table('two-epoch.final.summary', sep = '\t', header=TRUE)
stairway_xy = stairway_raw[,6:7]
dupe.filter = duplicated(stairway_xy[,1])
stairway.filtered = stairway_xy[!dupe.filter,]


df1 = data.frame(x=c(1,3,5), y1=c(1,1,1))
df2 = data.frame(x=c(1,2,3,4,5), y2=c(2,2,2,2,2))
merge(df1, df2, by=c('x'), all=TRUE)

##########################       FUNCTION AREA       ##########################

setwd("~/Desktop/pop_gen/project/stairway_summary")

stairway_plot <- function(dataset_name, plot_title, xlim=c(0, 250000), ylim=c(1000,15000)){
  files <- list.files(pattern = dataset_name)
  col_palette = brewer.pal(n = length(files), name = 'Set1')
  count = 1
  newplot = TRUE
  for (afile in files) {
    stairway_raw = read.table(afile, sep = '\t', header=TRUE)
    stairway_xy = stairway_raw[,6:7]
    if(newplot){
      plot(stairway_xy[,1], stairway_xy[,2], col=col_palette[count], type='l', 
           lwd=1.5, xlab = 'Years (kya)', ylab = 'Effective population size',
           main = plot_title, xlim = xlim, ylim = ylim)
      newplot = FALSE
    }
    else{
      lines(stairway_xy[,1], stairway_xy[,2], col=col_palette[count], lwd=1.5)
    }
    count = count + 1
  }
  
}

rep_variance <- function(dataset_name, round_digit=-2, merge_col='year', 
                          keep_col='Ne_median', data_range=2:4){ 
  files <- list.files(pattern = dataset_name)
  count = 1
  for (afile in files) {
    stairway_raw = read.table(afile, sep = '\t', header=TRUE)
    stairway_xy = stairway_raw[,6:7]    
    dupe.filter = duplicated(stairway_xy[,1])
    stairway.filtered = stairway_xy[!dupe.filter,]
    stairway.filtered[,1] = round(stairway.filtered[,1], digits = round_digit)
    colnames(stairway.filtered) = c(merge_col, paste0(keep_col, count, collapse=''))
    if(count == 1){
      merge_df = stairway.filtered
    }
    else{
      merge_df = merge(merge_df, stairway.filtered, by=c(merge_col), all=TRUE)
    }
    count = count + 1
  }
  merge_no_na = merge_df[complete.cases(merge_df),]
  merge_no_na$variance = apply(merge_no_na[,data_range], MARGIN=1, FUN=var)
  return(merge_no_na)
}


##########################       RUNNING AREA       ##########################

title_vec <- c('number of loci = 10000 loci\n (loci size = 10kb)', 
               'number of loci = 1000 loci (loci size = 10kb)',
               'number of loci = 100 loci (loci size = 10kb)', 
               'number of loci = 10000 loci (loci size = 10kb)', 
               'number of loci = 1000 loci (loci size = 10kb)', 
               'number of loci = 100 loci (loci size = 10kb)')

input_vec = c('single-pop-expand-10000-', 'single-pop-expand-1000-', 
              'single-pop-expand-100-', 'single-pop-constant-10000-', 
              'single-pop-constant-1000-', 'single-pop-constant-100-')

par(mfcol = c(3, 2))
for(i in 1:length(input_vec)){
  stairway_plot(input_vec[i], title_vec[i])
}


exp10k = rep_variance('single-pop-expand-10000-')
exp10k$mean = apply(exp10k[,2:4], MARGIN=1, FUN=mean)
exp10k$vmr = exp10k$variance/exp10k$mean



