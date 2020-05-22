
suppressWarnings(suppressMessages(suppressPackageStartupMessages({
	source("R/functions.R")
	library("ggplot2")
	library("dplyr")
	require(gridExtra)
	require(data.table)
})));

n = seq(1, 25);

H=function(){return(runif(1, 145, 200))}
L=function(){return(runif(1, 45, 92))}
tempo = matrix(c(H(), H(), H(), L(), H(), L(), L(), H(), L(), L(), L(), H(), H(), L(), L(), H(), L(), L(), L(), H(), L(), H(), H(), H(), H()), nrow=25, ncol=1);

H=function(){return(runif(1, .81, 1))}
L=function(){return(runif(1, 0, .37))}
valence = matrix( c(H(), L(), L(), H(), L(), L(), L(), H(), L(), H(), H(), H(), H(), H(), H(), L(), H(), L(), L(), H(), L(), L(), L(), H(), H()), nrow=25, ncol=1);

H=function(){return(runif(1, .61, 1))}
L=function(){return(runif(1, 0, .18))}
energy = matrix( c(H(), L(), L(), H(), L(), L(), L(), H(), L(), H(), H(), H(), H(), H(), H(), L(), H(), L(), L(), H(), L(), L(), L(), H(), H()), nrow=25, ncol=1);

d = data.table(cbind(n, tempo, valence, energy))
colnames(d) = c("track", "tempo", "valence", "energy")

p1=ggplot()+
	geom_rect(aes(xmin=0, xmax=25, ymin=0, ymax=92), color="turquoise", fill="turquoise", alpha=.5, size=0)+
	geom_rect(aes(xmin=0, xmax=25, ymin=145, ymax=210), color="salmon", fill="salmon", alpha=.5, size=0)+
	geom_line(data=d, aes(x=track, y=tempo), linetype="dashed", color="black")+
	geom_point(data=d, aes(x=track, y=tempo))+
	ylim(0, 210)

p2=ggplot()+
	geom_rect(aes(xmin=0, xmax=25, ymin=0, ymax=.37), color="turquoise", fill="turquoise", alpha=.5, size=0)+
	geom_rect(aes(xmin=0, xmax=25, ymin=.81, ymax=1), color="salmon", fill="salmon", alpha=.5, size=0)+
	geom_line(data=d, aes(x=track, y=valence), linetype="dashed", color="black")+
	geom_point(data=d, aes(x=track, y=valence))+
	ylim(0, 1)

p3=ggplot()+
	geom_rect(aes(xmin=0, xmax=25, ymin=0, ymax=.18), color="turquoise", fill="turquoise", alpha=.5, size=0)+
	geom_rect(aes(xmin=0, xmax=25, ymin=.61, ymax=1), color="salmon", fill="salmon", alpha=.5, size=0)+
	geom_line(data=d, aes(x=track, y=energy), linetype="dashed", color="black")+
	geom_point(data=d, aes(x=track, y=energy))+
	ylim(0, 1)

plt=grid.arrange(p1, p2, p3, ncol=1)

ggsave("dist/pattern_flat.png", plt, scale=1, dpi=300)
