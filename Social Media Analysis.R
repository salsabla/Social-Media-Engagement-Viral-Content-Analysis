#IMPORT DATASET
Data_Trend = read.csv("C:/Users/asus/Downloads/Dataset_Trend.csv", sep = ",")
Data_Trend
summary(Data_Trend)

#SETUP & CLEANING
library(tidyverse)
library(lubridate)
library(stringr)

Data_Trend <- Data_Trend %>%
  mutate(
    Post_Date = mdy(Post_Date),
    engagement = Likes + Shares + Comments,
    
    # proxy influencer
    influencer = ifelse(Engagement_Level == "High", 1, 0),
    
    # pseudo text
    content_text = paste(Hashtag, Content_Type),
    content_clean = content_text %>%
      str_to_lower() %>%
      str_remove_all("[^a-z\\s]")
  )

#TREN ANALYSIS
##tren jumlah post viral sebulan
Data_Trend_clean <- Data_Trend %>%
  dplyr::filter(!is.na(Post_Date))

trend_posts <- Data_Trend_clean %>%
  mutate(month = floor_date(Post_Date, "month")) %>%
  count(month)

ggplot(trend_posts, aes(month, n)) +
  geom_line() +
  labs(
    title = "Trend of Viral Posts Over Time",
    x = "Month",
    y = "Number of Posts"
  )
##tren engagement rata-rata
trend_engagement <- Data_Trend %>%
  mutate(month = floor_date(Post_Date, "month")) %>%
  group_by(month) %>%
  summarise(avg_engagement = mean(engagement))

ggplot(trend_engagement, aes(month, avg_engagement)) +
  geom_line() +
  labs(
    title = "Average Engagement Trend",
    x = "Month",
    y = "Average Engagement"
  )
##platform paling engaging
Data_Trend %>%
  group_by(Platform) %>%
  summarise(avg_engagement = mean(engagement)) %>%
  arrange(desc(avg_engagement))

#SENTIMENT MODELING (ROBUST)
library(tidytext)
library(dplyr)
library(ggplot2)

# -----------------------------
# 1. Tokenization
# -----------------------------
tokens <- Data_Trend %>%
  select(Post_ID, content_clean) %>%
  unnest_tokens(word, content_clean)

# -----------------------------
# 2. Sentiment score per post
# -----------------------------
sentiment_score <- tokens %>%
  inner_join(get_sentiments("bing"), by = "word") %>%
  mutate(score = ifelse(sentiment == "positive", 1, -1)) %>%
  group_by(Post_ID) %>%
  summarise(sentiment_score = sum(score), .groups = "drop")

# -----------------------------
# 3. Safe join + default value
# -----------------------------
Data_Trend <- Data_Trend %>%
  left_join(sentiment_score, by = "Post_ID")

if (!"sentiment_score" %in% colnames(Data_Trend)) {
  Data_Trend$sentiment_score <- 0
} else {
  Data_Trend$sentiment_score[is.na(Data_Trend$sentiment_score)] <- 0
}

# -----------------------------
# 4. Sentiment distribution (POST-LEVEL)
# -----------------------------
Data_Trend %>%
  mutate(
    sentiment_label = case_when(
      sentiment_score > 0 ~ "Positive",
      sentiment_score < 0 ~ "Negative",
      TRUE ~ "Neutral"
    )
  ) %>%
  count(sentiment_label) %>%
  ggplot(aes(sentiment_label, n, fill = sentiment_label)) +
  geom_col(show.legend = FALSE) +
  labs(
    title = "Sentiment Distribution of Viral Content",
    x = "Sentiment",
    y = "Number of Posts"
  )


#INFLUENCER MARKETING ANALYSIS
##engagement influencer vs non influencer
Data_Trend %>%
  group_by(influencer) %>%
  summarise(avg_engagement = mean(engagement))
##visualisasi engagement comparison
ggplot(Data_Trend, aes(factor(influencer), engagement)) +
  geom_boxplot() +
  scale_y_log10() +
  labs(
    x = "Influencer (1 = Yes, 0 = No)",
    y = "Engagement (log scale)",
    title = "Engagement Comparison: Influencer vs Non-Influencer"
  )
##sentiment influencer vs non influencer
Data_Trend %>%
  group_by(influencer) %>%
  summarise(avg_sentiment = mean(sentiment_score))

#MODEL LANJUTAN REGRESI
##transformasi log engagement
Data_Trend <- Data_Trend %>%
  mutate(log_engagement = log1p(engagement))
##model regresi utama
model_engagement <- lm(
  log_engagement ~ sentiment_score + influencer + Platform,
  data = Data_Trend
)

summary(model_engagement)
##interpretasi koefisien (% effect)
exp(coef(model_engagement)) - 1
##visual hubungan sentiment vs engagement
ggplot(Data_Trend, aes(sentiment_score, log_engagement)) +
  geom_point(alpha = 0.3) +
  geom_smooth(method = "lm", se = FALSE) +
  labs(
    title = "Effect of Sentiment on Engagement"
  )

