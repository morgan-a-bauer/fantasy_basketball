# Predictive Analytics for Fantasy Basketball

I am the co-commissioner of my family's annual fantasy basketball league. While my team often does well, my grandfather has a tendency to finish the season in first place. In an effort to upset this pattern, I have embarked on a journey to develop tools to improve my team's performance based on predictive analytics.

I began by generating a report to inform my draft rankings. Instead of using commonly observed statistics, I based my rankings on alternative sources of information (e.g. number of games played in the previous season, minutes played per game, and usage rate). To learn about building UIs with Shiny and R, I began developing other reports and visualizations I found useful throughout the season and consolidated them in a Shiny page. To improve my choices of which players to start and which to bench each day, I built a dataset containing statistics from games played by all active NBA players. I used this dataset to train a Recurrent Neural Network (RNN) to predict daily scores of each of my players based on their performances over their last ten games. I am currently working on using the Yahoo Fantasy API to gather statistics on the long-term performance of this model.

To test my recently developed tools, I participated in eight leagues during the 2023-2024 season. Six of those teams finished in the top three and two of them won their respective leagues. The success I have found from using these tools has increased my win percentage from 47.8% in the 2022-2023 season to 70.3% in the 2023-2024 season. My rating has improved from 578 to 831, improving my managerial status from bronze to platinum.

## Getting Started

This is a more disorganized repository and has evolved much over time. I intend on cleaning it up and making improvements but while I am busy with school and research engagements, I have not had the chance to do so.

### Prerequisites

This repository consists of multiple parts requiring different dependencies. R scripts that generate reports use the `tidyverse`, `mosaic`, `rvest`, `methods`, `lubridate`, and `stringi` libraries. In addition to the previously mentioned R libraries, the app utilizes `shiny` , `shinydashboard`, and `RColorBrewer`. The machine learning component is written in Python, utilizes Jupyter Notebooks, and uses `numpy`, `matplotlib`, `tensorflow`, `keras`, and `pandas`, in addition to the built-in `os` and `csv` modules.

### Using the solver

The `denominator_reports.R` script generates draft rankings in dataframe form. Using [Basketball-Reference](https://www.basketball-reference.com/), this script uses stats from previous seasons to rank players in a potential draft order.

The Shiny app can be accessed by running the `app2.R` script in the `analytics_app` directory.

To use the RNN to predict player scores, ensure that `basic_score_predicition.keras` is installed. The cells you will need to run are under the "Predict scores" heading. Adjust the path when loading the model to the proper location on your machine and adjust `PLAYER_ID` as necessary.

## Authors

* **Morgan Bauer**

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

* [Basketball-Reference](https://www.basketball-reference.com/) for consolidating and providing great basketball stats
* My grandfather for inspiring my competetive spirit
* The many books I have read about sports analytics
