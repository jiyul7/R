RE = read.csv('C:/GitHub/R/Exercise/d01_code/sigun_code/sigun_code.csv')
head(RE, n=3)
str(RE)
summary(RE$code)
library(tm)

CORPUS = Corpus(VectorSource(RE$sigungu))
tdm = DocumentTermMatrix((CORPUS))
inspect(tdm)

# console clear : 명령어는 못찾겠고, Ctrl+L

price ="30,000"
price
sub(",", "", price)
price
