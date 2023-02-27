
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

# 4단계 : 건축 연도, 전용면적 변환하기
head(apt_price$conYear, 3)
# 문자형 --> 숫자형
# 건축연도
#apt_price$conYear = apt_price$conYear %>% as.numeric()
apt_price$conYear = as.numeric(apt_price$conYear)
# 전용면적
apt_price$area = apt_price$area %>% as.numeric() %>% round(0)
head(apt_price$area, 3)

# 5단계 : 평당 매매가
# 평단가
# py항목이 기정의되어 있지 않아도, 자동 생성됨
# %>% 연산자 앞에는 ()로 끝나도록 묶어야 함
apt_price$py = ((apt_price$price / apt_price$area) * 3.3) %>% round(0)
head(apt_price, 3)
# 6단계 : 층수 변환
min(apt_price$floor)
apt_price$floor = apt_price$floor %>% as.numeric() %>% abs()
min(apt_price$floor)
# 모든 행에 값이 1인 컬럼 추가 (거래 건수 파악이 목적)
apt_price$cnt = 1
head(apt_price, 3)

# 04-3 전처리 데이터 저장하기

# 1단계: 필요한 컬럼만 추출
apt_price = apt_price %>% select(ymd, ym, year, code, addr_1, aptNm, jusoJibun, price, conYear, area, floor, py, cnt)
head(apt_price, 3)
# 2단계: 전처리 데이터 저장
setwd(dirname(rstudioapi::getSourceEditorContext()$path)) 
dir.create("./d04_pre_process")
save(apt_price, file = "./d04_pre_process/04_pre_process.rdata")
write.csv(apt_price, "./d04_pre_process/04_pre_process.csv")
