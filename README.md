# Social-Media-Engagement-Viral-Content-Analysis
This project is an end-to-end data analysis portfolio using R to explore trends in social media viral content. The analysis covers engagement trends, viral post dynamics, sentiment analysis, influencer comparison, and a regression model to understand factors affecting engagement.

Dataset size: 5,000 posts across multiple platforms (YouTube, Instagram, Twitter, TikTok).

## Objectives
1. Analyze monthly trends of viral posts
2. Measure average engagement over time
3. Compare engagement between influencer & non-influencer posts
4. Examine sentiment distribution of viral content
5. Model the effect of sentiment, platform, and influencer status on engagement

## Trend of Viral Post Over Time
<img width="945" height="768" alt="image" src="https://github.com/user-attachments/assets/adf52479-4f81-41ea-8465-fde86026c99f" />

This plot presents the number of viral posts published per month. The volume of viral posts fluctuates throughout the observed period, with certain months showing higher activity. This indicates that viral content creation is irregular and cyclical, potentially influenced by global events, seasonal trends, or shifts in platform algorithms. When compared with the average engagement trend, an increase in the number of viral posts does not necessarily correspond to higher engagement levels.

**Conclusion:** 
A higher volume of viral posts does not guarantee higher audience engagement, highlighting the importance of content quality over quantity.

## Average Engagement Trend
<img width="945" height="768" alt="image" src="https://github.com/user-attachments/assets/01df2a86-8c2d-4cb5-a644-b2865fb2f2a7" />

This plot illustrates the monthly average engagement (likes, shares, and comments combined) of viral social media posts over time. The trend shows noticeable fluctuations across months, indicating that engagement levels are not stable. Several months experience significant spikes, suggesting periods of heightened audience interaction, possibly driven by trending topics, seasonal events, or platform-specific algorithm boosts. There is no clear long-term upward or downward trend, implying that engagement is largely event-driven rather than time-dependent.

**Conclusion:** 
Average engagement on viral content varies substantially over time and is influenced by external momentum rather than consistent growth.

## Platform Level Engagement Analysis

| Platform   | Average Engagement |
|------------|-------------------:|
| YouTube    | 333,708 |
| Instagram  | 332,387 |
| Twitter    | 320,565 |
| TikTok     | 320,454 |

**Interpretation:**  
YouTube shows the highest average engagement, followed closely by Instagram, while Twitter and TikTok exhibit slightly lower but comparable engagement levels.

## Sentiment Distribution of Viral Content
<img width="945" height="768" alt="image" src="https://github.com/user-attachments/assets/095b4706-ac87-409d-9c7b-ddf643582940" />

The sentiment distribution indicates that all posts are classified as neutral. This outcome is expected, as the textual features used in the analysis consist primarily of hashtags and content types, which contain limited emotional vocabulary. Consequently, lexicon-based sentiment analysis yields neutral scores across posts.

## Engagement Comparison: Influencer vs Non Influencer
<img width="945" height="768" alt="image" src="https://github.com/user-attachments/assets/8ec2d1ce-005d-4612-bc75-5950cc7dcbef" />

This boxplot compares engagement distributions between influencer and non-influencer posts using a logarithmic scale. The medians and interquartile ranges of both groups are remarkably similar, and both categories exhibit substantial variability and outliers. This suggests that influencer posts do not consistently outperform non-influencer posts in terms of engagement. High engagement outliers are present in both groups, indicating that virality is not exclusive to influencers.

**Conclusion**
Influencer status alone is not a decisive factor in achieving higher engagement.

# Regression Analysis: Factors Affecting Engagement
To examine the factors influencing social media engagement, a multiple linear regression model was estimated using log-transformed engagement as the dependent variable. The logarithmic transformation (log1p) was applied to reduce skewness and improve interpretability of coefficient effects.

**Model Specification**
log_engagement ~ sentiment_score + influencer + Platform
Where:
1. log_engagement represents the natural logarithm of total engagement.
2. sentiment_score is a lexicon-based sentiment measure derived from post text.
3. influencer is a binary indicator of influencer status.
4. Platform is a categorical variable representing the social media platform.

## Regression Results Summary
Call:
lm(formula = log_engagement ~ sentiment_score + influencer + 
    Platform, data = Data_Trend)

Residuals:
    Min      1Q  Median      3Q     Max 
-3.1491 -0.3380  0.1405  0.4565  0.8064 

Coefficients: (1 not defined because of singularities)
                 Estimate Std. Error t value Pr(>|t|)    
(Intercept)     12.576117   0.017509 718.246   <2e-16 ***
sentiment_score        NA         NA      NA       NA    
influencer      -0.001906   0.017352  -0.110   0.9125    
PlatformTikTok  -0.039946   0.023287  -1.715   0.0863 .  
PlatformTwitter -0.035762   0.023557  -1.518   0.1290    
PlatformYouTube  0.011533   0.023010   0.501   0.6162    
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 0.5787 on 4995 degrees of freedom
Multiple R-squared:  0.0015,	Adjusted R-squared:  0.0006999 
F-statistic: 1.875 on 4 and 4995 DF,  p-value: 0.1118

The regression output indicates that sentiment score could not be estimated, as it was excluded from the model due to singularity. This occurs because sentiment scores exhibit little to no variation, with most posts classified as neutral. As a result, the model is unable to identify a distinct effect of sentiment on engagement.

Influencer status does not show a statistically significant effect on engagement, suggesting that posts created by influencers do not consistently outperform non-influencer posts once platform differences are accounted for.

Platform-level effects are relatively small and statistically insignificant. Compared to the baseline platform (Instagram), TikTok and Twitter show slightly lower average engagement, while YouTube shows a marginally higher engagement level. However, none of these differences reach conventional significance thresholds.

## Model Fit and Explanatory Power
The overall model explains a very small proportion of engagement variance (Adjusted R² ≈ 0.001), and the F-test indicates that the model is not statistically significant as a whole. This suggests that engagement dynamics are not well explained by sentiment, influencer status, or platform alone.

## Insights
These results imply that viral engagement is largely driven by factors beyond surface-level textual sentiment and creator identity. Elements such as content format, timing, audience behavior, and platform-specific algorithms likely play a more substantial role in shaping engagement outcomes.

The regression findings are consistent with the sentiment distribution analysis and the visualization of sentiment versus engagement, both of which show no clear relationship between sentiment and engagement levels.

# Methodological Note
Sentiment analysis in this study is based on pseudo-text constructed from hashtags and content type labels. As this text contains limited emotional vocabulary, sentiment scores are predominantly neutral and should be interpreted with caution

# Overall Interpretation
Collectively, these plots demonstrate that social media engagement is a complex phenomenon influenced by multiple interacting factors. While positive sentiment and influencer status are commonly assumed to drive virality, the analysis shows that timing, platform dynamics, and content format likely play a more significant role.
