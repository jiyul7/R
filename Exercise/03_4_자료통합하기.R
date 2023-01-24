
library(rstudioapi)
library(plyr)

setwd(dirname(rstudioapi::getSourceEditorContext()$path)) # 작업폴더 설정
getwd()   # 확인

# 파일명 추출
files = dir("./d02_raw_data")
files
# 디렉토리명 붙여줌
paste0("./d02_raw_data/", files)

# 파일 full명으로 읽은 데이터(리스트형태)를 데이터프레임 형태로 통합
apt_price = ldply(as.list(paste0("./d02_raw_data/", files)), read.csv)

head(apt_price,5)
tail(apt_price,5)

# 통합 파일 저장하기
dir.create("./d03_integrated")
save(apt_price, file="./d03_integrated/03_apt_price.rdata")
write.csv(apt_price, "./d03_integrated/03_apt_price.csv")
