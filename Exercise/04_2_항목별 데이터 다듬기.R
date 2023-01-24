
library(rstudioapi)

setwd(dirname(rstudioapi::getSourceEditorContext()$path)) # 작업폴더 설정
getwd()   # 확인

# 01.파일로드
load("./d03_integrated/03_apt_price.rdata")

head(apt_price,5)

# 02.결측값과 공백 제거하기
# 결측값 확인(na: not available), TRUE가 결측값
table(is.na(apt_price))

# 결측값 제거
apt_price = na.omit(apt_price)

# 앞뒤 공백제거
head(apt_price$price, 5)
library(stringr)
# 데이터프레임 전체에 공백제거 apply 두번째 파라미터 (1: 행, 2:열)
apt_price = as.data.frame(apply(apt_price, 2, str_trim))

head(apt_price$price, 5)

class(apt_price[[1]])

# 매매 연월일, 연월 데이터 만들어서 맨 뒤에 덧붙이기
library(lubridate)
library(dplyr)

# 아래 2가지 방법 모두 동일 결과
# apt_price = apt_price %>% mutate(ymd=make_date(year, month, day))
apt_price = mutate(apt_price, ymd=make_date(year, month, day))

apt_price$ym = floor_date(apt_price$ymd, "month")
head(apt_price, 5)

# 매매가 변환 (문자 --> 숫자)
apt_price$price = sub(",", "", apt_price$price) %>% as.numeric()
head(apt_price$price, 5)

# 아파트 이름 현황
head(apt_price$aptNm, 30)

# 아파트 이름에서 괄호 이후 삭제 : 괄호인식문제로 \\ 붙임
apt_price$aptNm = gsub("\\(.*", "", apt_price$aptNm)

# 주소 조합
# 지역코드 불러오기
loc = read.csv("./d01_code/sigun_code/sigun_code.csv", fileEncoding = "UTF-8")
# 지역명 결합하기
apt_price = merge(apt_price, loc, by ='code')
# 주소 조합
apt_price$jusoJibun = paste0(apt_price$addr_2, " ", apt_price$dongNm, " ", apt_price$jibun, " ", apt_price$aptNm)
head(apt_price, 5)
