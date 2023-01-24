
library(rstudioapi)
library(XML)
library(data.table)
library(stringr)

setwd(dirname(rstudioapi::getSourceEditorContext()$path)) # 작업폴더 설정
getwd()   # 확인

loc <- read.csv("C:\\GitHub/R/Exercise/d01_code/sigun_code/sigun_code.csv", fileEncoding="UTF-8")  #  지역코드
loc$code <- as.character(loc$code) # 행정구역명 문자 변환     
head(loc, 2) # 확인

# 날짜 세팅
datelist <- seq(from = as.Date('2021-01-01'),
                to = as.Date('2021-03-31'),
                by = '1 month')
datelist <- format(datelist, format='%Y%m')
datelist[1:3]

# data portal key
serviceKey <- 'fQt2dRi7TZxBFIMypcLbpssMXYLmKJPcr5kkgrX4jDQrynLz9SwRKURgJdn8H%2BHUTpLi9pXjZYkQNtZuWQXrhw%3D%3D'

# 요청 목록 만들기
urlList <- list()
cnt <- 0
for (i in 1:nrow(loc)) {
  for (j in 1:length(datelist)){
    cnt <- cnt + 1
    urlList[cnt] <- paste0("http://openapi.molit.go.kr:8081/OpenAPI_ToolInstallPackage/service/rest/RTMSOBJSvc/getRTMSDataSvcAptTrade?",
                      "LAWD_CD=", loc[i,1],
                      "&DEAL_YMD=", datelist[j],
                      "&serviceKey=", serviceKey)
  }
  Sys.sleep(0.1)  # 0.1 sec
  msg <- paste0("[", i, "/", nrow(loc), "] ", loc[i,3], "크롤링 목록 생성됨. (총 ", cnt, ") 건" )
  cat(msg, "\n\n")
}
length(urlList)
# browseURL(paste0(urlList[1]))

# 임시 저장 리스트 생성
rawData <- list()
rootNode <- list()
total <- list()

# URL 요청 및 응답 저장
for(i in 1:length(urlList)) {
  rawData[[i]] <- xmlTreeParse(urlList[i], useInternalNodes = TRUE, encoding = 'utf-8')
  rootNode[[i]] <- xmlRoot(rawData[[i]])
  
  
  # 전체 거래 건수 확인
  items <- rootNode[[i]][[2]][['items']]
  size <- xmlSize(items)
  
  # 거래 내역 추출
  item <- list()
  itemTempDt <- data.table()
  Sys.sleep(0.1)
  
  for (m in 1:size){
    itemTemp <- xmlSApply(items[[m]], xmlValue)
    itemTempDt <- data.table(year = itemTemp[4],
                             month = itemTemp[7],
                             day = itemTemp[8],
                             price = itemTemp[1],
                             code = itemTemp[12],
                             dongNm = itemTemp[5],
                             jibun = itemTemp[11],
                             conYear = itemTemp[3],
                             aptNm = itemTemp[6],
                             area = itemTemp[9],
                             floor = itemTemp[13])
    item[[m]] <- itemTempDt
  }
  aptBind <- rbindlist(item)
  
  # 응답 내용 저장
  regionNm <- subset(loc, code == str_sub(urlList[i], 115, 119))$addr_1  # 지역명
  month <- str_sub(urlList[i], 130, 135)
  path <- as.character(paste0("C:\\GitHub/R/Exercise/d02_raw_data/", regionNm, "_", month, ".csv"))
  write.csv(aptBind, path)
  msg = paste0("[", i, "/", length(urlList), "] 수집한 데이터를 [", path, "]에 저장합니다")
  cat(msg, "\n\n")
}
