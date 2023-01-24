# install.packages("rstudioapi")
# install.packages("XML")
# install.packages("data.table")
#install.packages("Rtools42")
# install.packages("stringr")
#install.packages("languageserver")
#install.packages("tm")

#lib 설치시 주의사항
#1. Rstudio를 관리자권한으로 실행
#2. 매번 아래 명령어 해줘야 아래에 설치
.libPaths("C:\\Program Files/R/R-4.2.1/library")
Sys.getenv("R_LIBS")
.libPaths()
#[1] "C:/Users/jiyul/AppData/Local/R/win-library/4.2" "C:/Program Files/R/R-4.2.1/library"            
install.packages("plyr")
install.packages("dplyr")
install.packages("lubridate")
