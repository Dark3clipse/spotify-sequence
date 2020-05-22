
# includes
suppressWarnings(suppressMessages(suppressPackageStartupMessages({
	.libPaths("~/R/x86_64-pc-linux-gnu-library/3.5/")
	source("R/functions.R")
	library("dplyr")
	require(data.table)
	require('digest')
})));

# where is the data located?
data_location = "/media/shadash/321cfbdb-669b-484c-bf65-5e5e3ffbb541/"

# read tardump
con = file(paste(data_location, "db/tardump", sep=""), "r")
sessions = 0
while ( TRUE ) {
	line = readLines(con, n = 1)
	if ( length(line) == 0 ) {
		break
	}



	# read csv data chunk
	print(paste("reading file", line))
	d <- read.table(paste(data_location, line, sep=""), TRUE, ",")#, nrows=2000

	print("processing")
	d = d %>% mutate(session_id = sessions + as.numeric(factor(session_id)))
	sessions = d$session_id[nrow(d)]

	#print("processing 1")
	d = d %>% mutate(skip_1 = if_else(skip_1 == "true", 1, 0))
	#print("processing 2")
	d = d   %>% mutate(skip_2 = if_else(skip_2 == "true", 1, 0))
	#print("processing 3")
	d = d   %>% mutate(skip_3 = if_else(skip_3 == "true", 1, 0))
	#print("processing 4")
    d = d   %>% mutate(not_skipped = if_else(not_skipped == "true", 1, 0))
	#print("processing 5")
    d = d   %>% mutate(hist_user_behavior_is_shuffle = if_else(hist_user_behavior_is_shuffle == "true", 1, 0))
	#print("processing 6")
    d = d   %>% mutate(premium = if_else(premium == "true", 1, 0))
	#print("processing 7")
    #d = d   %>% mutate(session_id = sapply(session_id, function(x){return(digest(x, algo=c("crc32"), serialize=T, file=F,length=Inf, skip="auto", ascii=FALSE, raw=T, seed=565))}))
	#print("processing 8")
	#d = d   %>% mutate(track_id_clean = sapply(track_id_clean, function(x){return(digest(x, algo=c("crc32"), serialize=T, file=F,length=Inf, skip="auto", ascii=FALSE, raw=T, seed=565))}))
    #print("processing 9")
	d = d   %>% mutate(context_type = if_else(context_type == "catalog", 0, if_else(context_type == "charts", 1, if_else(context_type=="editorial_playlist", 2, if_else(context_type=="personalized_playlist", 3, if_else(context_type=="radio", 4, 5))))))
    #print("processing 10")
	d = d   %>% mutate(hist_user_behavior_reason_start = if_else(hist_user_behavior_reason_start == "appload", 0, if_else(hist_user_behavior_reason_start == "backbtn", 1, if_else(hist_user_behavior_reason_start=="clickrow", 2, if_else(hist_user_behavior_reason_start=="endplay", 3, if_else(hist_user_behavior_reason_start=="fwdbtn", 4, if_else(hist_user_behavior_reason_start=="popup", 5, if_else(hist_user_behavior_reason_start=="playbtn", 6, if_else(hist_user_behavior_reason_start=="clickside", 7, if_else(hist_user_behavior_reason_start=="remote", 8, if_else(hist_user_behavior_reason_start=="trackdone", 9, if_else(hist_user_behavior_reason_start=="trackerror", 10, 11))))))))))))
	#print("processing 11")
	d = d   %>% mutate(hist_user_behavior_reason_end = if_else(hist_user_behavior_reason_end == "appload", 0, if_else(hist_user_behavior_reason_end == "backbtn", 1, if_else(hist_user_behavior_reason_end=="clickrow", 2, if_else(hist_user_behavior_reason_end=="endplay", 3, if_else(hist_user_behavior_reason_end=="fwdbtn", 4, if_else(hist_user_behavior_reason_end=="popup", 5, if_else(hist_user_behavior_reason_end=="playbtn", 6, if_else(hist_user_behavior_reason_end=="clickside", 7, if_else(hist_user_behavior_reason_end=="remote", 8, if_else(hist_user_behavior_reason_end=="trackdone", 9, if_else(hist_user_behavior_reason_end=="trackerror", 10, 11))))))))))))

	print("writing")
	write.csv(d, paste("~/d/", line, "-mod.csv", sep=""), row.names=FALSE)

	# context_type:
	#catalog = 0
	#charts = 1
	#editorial_playlist = 2
	#personalized_playlist = 3
	#radio = 4
	#user_collection = 5
	#'catalog','charts','editorial_playlist','personalized_playlist','radio','user_collection'
	#SET GLOBAL innodb_buffer_pool_size=402653184

	# $hist_user_behavior_reason_start
	# appload = 0
	# backbtn = 1
	# clickrow = 2
	# endplay = 3
	# fwdbtn = 4
	# popup = 5
	# playbtn = 6
	# clickside = 7
	# remote = 8
	# trackdone = 9
	# trackerror = 10
	# logout = 11
	# 'appload','backbtn','clickrow','endplay','fwdbtn','popup','playbtn','clickside','remote','trackdone','trackerror','logout'

	rm(d)
	#break;
}
close(con)

Sys.sleep(2000)
