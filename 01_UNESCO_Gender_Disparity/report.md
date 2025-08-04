# Gender disparities in school completion rates: A cross-country analysis using the UNESCO API

In the ever-evolving world of data science, learning how to access and analyze real-world data is one of the most valuable skills a researcher or analyst can build. This week, I stepped out of my comfort zone and explored something new that is extracting and visualizing education data using the UNESCO Institute for Statistics (UIS) API.

This was my first hands-on experience with working directly with an API to fetch data and and it turned out to be challenging yet rewarding. Below, I share my process, insights and key takeaways.

## What is “Completion rate” ?
Before diving into the analysis, it is critical to define the key metric. According to UNESCO, the completion rate measures the percentage of a population that has successfully completed a given level of education. For instance, the primary education completion rate tells us what percentage of children typically of primary school age (or older) have completed the final grade of primary school.

This metric is crucial because it helps us move beyond enrolment numbers and instead understand how many students persist through to the end of a schooling cycle, an important measure of both access and retention.

For this project, I focused on:

- Primary completion (CR.1): The proportion of children completing the final grade of primary school.
- Lower secondary completion (CR.2): The proportion completing the final grade of lower secondary education.

Disaggregating these rates by gender helps identify systemic gaps, for example, whether boys or girls face greater barriers to completion.

## The technical approach
The real learning began when I started working directly with UNESCO’s API for the first time. UNESCO’s API provides an easy access to global education datasets. Their API training documentation was really helpful for me to construct queries to extract completion rate data by gender for India, Nepal and Bangladesh. Using R’s httr and jsonlite packages, I wrote a function that could fetch data for each combination of country and indicator that is primary completion rates for females (CR.1.F) and males (CR.1.M), plus lower secondary rates for both genders (CR.2.F and CR.2.M). These three countries were chosen for their diverse educational contexts and contrasting progress in gender equity.

Indicators used: CR.1.F / CR.1.M: Primary completion rates (female/male). Countries: India, Nepal and Bangladesh, three nations with diverse education challenges.

## What does the data show?
With a clean dataset, I created interactive tables allowing users to explore data points and line charts visualizing trends across countries and genders over the years. Completion rate trajectories varied between the three countries, likely reflecting differences in education policies, resource allocation and other factors. There were a few data gaps where records were missing for certain years. The trends revealed important differences across countries and between genders.

The comparative analysis shows distinct educational trajectories across these three South Asian nations. India consistently showed the highest overall completion rates, especially at the primary level. However, gender disparities persisted at the lower secondary level, indicating that while access to basic education has improved, continuation into higher grades remains uneven, possibly due to regional or socioeconomic barriers.

Nepal’s data demonstrates the most notable progress in gender equity. The visualization shows a consistent upward trajectory in completion rates for both genders, with girls’ rates accelerating particularly at the lower secondary level. This is likely due to targeted policy interventions and community-based education programmes.

Bangladesh’s completion rates showed more year-to-year variability compared to other two. Overall trends indicated significant improvements for both boys and girls. The data suggests Bangladesh has made strides in keeping girls in school through the lower secondary level.

## Want to explore the code?
Here is the link to the full HTML report exported from R http://rpubs.com/preeti_m93/UNESCO_API

Try swapping in other indicator or country codes to explore more!

