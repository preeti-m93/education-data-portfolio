# Hierarchical and Mixed Effects Models in R

## Overview

This project explores hierarchical and mixed-effects models using simulated multi-level educational data. The goal was to examine how modeling clustered structures such as students within classrooms and schools improves the accuracy of statistical analysis when evaluating educational interventions.

# What is a hierarchical model?
Imagine you’re looking at student progress in schools. In education and many other fields, data are naturally grouped or “nested.” Students learn within classrooms and classrooms exist within schools. Students in the same class may have more in common with each other than with students in a different class because they share the same teacher or environment.

Hierarchical models, also known as multi-level models or mixed-effects models, are statistical methods designed to handle such nested or “group within group” data structures. They help us answer questions like:

Is a student’s improvement mostly due to their own ability or does the classroom or school they’re in play a big role?
How much do teachers, classrooms and schools contribute to student growth?
Unlike simple regression methods which assume that each observation is independent, hierarchical models recognize ****the real-world structure of our data.

For instance, Grade 4 has 35 students, while Grade 2 has just 10. With such a small group, the Grade 2’s average test scores are more likely to fluctuate due to chance, potentially resulting in extreme highs or low, as explained by the law of large numbers. By including classrooms as a random effect in our model, we can pool “share” information about average performance across the classrooms within the same school, leading to more stable and accurate estimates. Additionally, if we track the same group of students over multiple years, their scores from year to year are no longer independent. In this case, repeated-measures analysis, a type of hierarchical model, helps us account for this dependence in the data.

# Why hierarchical models matter?
Hierarchical models account for the dependency among observations by introducing two types of effects:

Fixed effects: coefficients that estimate the overall (‘population‑level’) relationship between predictors and outcomes (e.g., the general effect of prior math knowledge on learning gains).
Random effects: terms that capture how this relationship varies across groups (e.g., different intercepts for each classroom).
These models are essential when your data is clustered, you need to separate individual and group effects or you have imbalanced data such as different group sizes or missing values.


## What I did
I then simulated a dataset of 600 students nested within 40 classrooms across 5 schools. Each student had characteristics such as prior math knowledge, socioeconomic status, sex, and whether they received an intervention.

I conducted exploratory data analysis and built several models:

- A simple linear model ignoring the data hierarchy
- A classroom-aggregated model using classroom-level means
- A fixed-effects model with classroom as a factor
- A hierarchical model with classroom as a random intercept
- A hierarchical model with classrooms nested within schools as random effects

For each model, I analyzed the significance of predictors like prior math knowledge, intervention status, SES, and sex. I compared model performance using output summaries and visualizations such as observed vs. predicted plots.

## What I found

- **Simple Linear Model**: Prior math knowledge, intervention, SES, and sex significantly predicted math gains. However, the model ignored the nested structure, leading to potential underestimation of standard errors.

- **Classroom-Level Aggregation**: Averaging at the classroom level led to a significant loss in explanatory power. The variation within classrooms was lost, and only prior knowledge remained a strong predictor.

- **Fixed Effects Model**: Controlling for classroom-specific effects improved the model, explaining more variance. But this approach used many degrees of freedom and became less scalable with increasing group numbers.

- **Random Intercepts (Classroom)**: Including classroom as a random intercept led to improved model performance and better accounted for group-level variance. All predictors remained significant, and the model was more efficient than fixed effects.

- **Nested Random Effects (School/Classroom)**: Modeling both school and classroom effects provided the most realistic structure. Prior math knowledge and intervention were again the strongest predictors. The model revealed that school-level factors contributed more variance than classroom-level ones, underscoring the importance of accounting for both levels in educational research.

- **Prediction Accuracy**: The final hierarchical model produced predictions closely aligned with observed math gains, as visualized in the observed vs. predicted plot. This demonstrated the model's reliability in capturing true effects while accounting for hierarchical structure.

## Conclusion

This project illustrates why hierarchical models are essential when analyzing nested data. They help prevent underestimated uncertainty, offer more generalizable insights, and capture variance at different levels (student, classroom, school). Ignoring the hierarchical nature of data can lead to misleading conclusions, especially when evaluating the impact of interventions. These models are particularly valuable in education research, where learning environments are inherently multi-layered.

## References

- Bates, D., Mächler, M., Bolker, B., & Walker, S. (2015). Fitting Linear Mixed-Effects Models Using lme4. *Journal of Statistical Software*, 67(1), 1–48.
- Gelman, A., & Hill, J. (2006). *Data Analysis Using Regression and Multilevel/Hierarchical Models*. Cambridge University Press.
- Pinheiro, J. C., & Bates, D. M. (2000). *Mixed-Effects Models in S and S-PLUS*. Springer.
- Raudenbush, S. W., & Bryk, A. S. (2002). *Hierarchical Linear Models: Applications and Data Analysis Methods* (2nd ed.). Sage.
- Snijders, T. A. B., & Bosker, R. J. (2012). *Multilevel Analysis: An Introduction to Basic and Advanced Multilevel Modeling* (2nd ed.). Sage.


