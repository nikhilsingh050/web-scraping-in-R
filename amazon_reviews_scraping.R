library("xml2")
library("rvest")
library("methods")
library("stringr")

#read html source
url <- "https://www.amazon.in/Micromax-Canvas-Infinity-18-9/dp/B075NKHHBV/ref=cm_cr_arp_d_bdcrb_top?ie=UTF8"
productPage <- read_html(url)


#scrape html page title
Pagetitle <- productPage  %>% html_node("title") %>% html_text()
Pagetitle


#scrape specifications to specs.txt
capture.output(productPage %>% html_nodes(".col1 td") %>% html_text(), file="specs.txt",append=FALSE)


#scrape product name
title <- productPage  %>% html_node("#productTitle") %>% html_text()

#write product name to file
fileConn<-file("product-title.txt")
writeLines(c(title), fileConn)
close(fileConn)


#scrape image
image <- NA
image <- productPage %>% html_node("#landingImage") %>% html_attr("src") 
capture.output(str_replace_all(image, "[\r\n]" , ""), file="imageData.txt", append=FALSE)


fileConn<-file("userReviews.txt")
write(c(""), fileConn)
close(fileConn)


#scrape reviews
userReviewsPage <- productPage %>% html_nodes(".a-link-emphasis") %>% html_attr("href")
userReviewsPage
userReviewsPage = paste("http://www.amazon.in",userReviewsPage[1],sep="")
userReviewsPage
while (userReviewsPage != "http://www.amazon.in") { 
  allReviews <- read_html(userReviewsPage);
  review <- allReviews %>%  html_nodes(".review-text")  %>%  html_text()
  capture.output( str_replace_all(review, "\n            " , ""),file="userReviews.txt", append=TRUE)
  
  userReviewsPage = allReviews %>% html_nodes(".a-last a") %>% html_attr("href") 
  userReviewsPage = paste("http://www.amazon.in",userReviewsPage,sep="")
  
  Sys.sleep(3)
}
