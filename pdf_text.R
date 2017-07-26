library(pdftools)
library(tiff)
library(tesseract)

dest <- "C:/Users/XXXX/YYY/ZZZ"

# make a vector of PDF file names
myfiles <- list.files(path = dest, pattern = ".pdf",  full.names = TRUE)

sapply(myfiles, FUN = function(i){
  file.rename(from = i, to =  paste0(dirname(i), "\\", gsub(" ", "", basename(i))))
})

lapply(myfiles, function(i){
  for(j in 1:pdf_info(i)$pages){
    bitmap <- pdf_render_page(i, dpi = 300, numeric = TRUE,page = j)
    tiff::writeTIFF(bitmap,paste0(strsplit(i,"[.]")[[c(1,1)]], j , ".tiff", collapse = "_"))
  }
})

myfilestiff <- list.files(path = dest, pattern = ".tiff",  full.names = TRUE)

for(k in 1:(length(myfilestiff))){
  out <- ocr(myfilestiff[[k]])
  write.csv(out, paste0(strsplit(myfilestiff[[k]],"[.]")[[c(1,1)]],".txt"), row.names = FALSE) 
}
