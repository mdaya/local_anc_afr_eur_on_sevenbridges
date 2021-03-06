args <- commandArgs(trailingOnly = TRUE)
chr <- args[1]
in.bed.name <- args[2]
out.bed.name <- args[3]

#Prevent scientific notation of positions
options(scipen=999)

#Read  inout bed file
bed <- read.table(in.bed.name, stringsAsFactors=F)
bed <- bed[(bed$V1 == paste0("chr", chr)) | (bed$V1 == chr),]
bed <- bed[!duplicated(bed$V2),]

#Create and write output bed file
snp.id.split <- unlist(strsplit(bed$V4, split=":"))
hg38.pos <- as.numeric(snp.id.split[seq(2,nrow(bed)*4,4)]) 
ref <- snp.id.split[seq(3,nrow(bed)*4,4)] 
alt <- snp.id.split[seq(4,nrow(bed)*4,4)] 
out.bed <- data.frame(
  CHR=bed$V1,
  FROM=hg38.pos,
  TO=hg38.pos,
  REF=ref,
  ALT=alt,
  HG19=bed$V2
)
out.bed <- out.bed[order(out.bed$FROM),]

write.table(out.bed, out.bed.name,  sep="\t", quote=F, row.names=F, col.names=F)
