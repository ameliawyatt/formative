######## R script to create the sample dataframe

# Script should be located in the code directory
# Written to run in the formative directory 

rm(list=ls())

########

# read in list of indexes to be in the sample and the BMX data
sampleIds <- read.table("data/derived/indexList_in.txt", header=F, col.names='Index')
BMXData <- read.csv("data/original/BMX_D.csv")

# add 1 indicator to all sampleIds entries - they will all be in the sample
sampleIds$inSample <- 1
head(sampleIds)

# add unique indexes from sampleIds and BMX data to allIds, preserving columns
allIds <- merge(BMXData, sampleIds, by.x='SEQN', by.y='Index', all.x=T, all.y=T)
head(allIds)

# replace NA values with 0 - these indexes unique to BMX data will not be in the sample
allIds$inSample[is.na(allIds$inSample)] <- 0
head(allIds)

# write sample csv
write.csv(x = allIds[,c('SEQN', 'inSample')], file="data/derived/sample.csv")

#check csv
sample <- read.csv("data/derived/sample.csv")
head(sample)
