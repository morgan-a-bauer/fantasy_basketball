# Predictive Analytics for Fantasy Basketball

I am the co-commissioner of my family's annual fantasy basketball league. While my team often does well, my grandfather has a tendency to finish the season in first place. In an effort to upset this pattern, I have embarked on a journey to develop tools to improve my team's performance based on predictive analytics.

I began by generating a report to inform my draft rankings. Instead of using commonly observed statistics, I based my rankings on alternative sources of information (e.g. number of games played in the previous season, minutes played per game, and usage rate). To learn about building UIs with Shiny and R, I began developing other reports and visualizations I found useful throughout the season and consolidated them in a Shiny page. To improve my choices of which players to start and which to bench each day, I built a dataset containing statistics from games played by all active NBA players. I used this dataset to train a Recurrent Neural Network (RNN) to predict daily scores of each of my players based on their performances over their last ten games. I am currently working on using the Yahoo Fantasy API to gather statistics on the long-term performance of this model.

To test my recently developed tools, I participated in eight leagues during the 2023-2024 season. Six of those teams finished in the top three and two of them won their respective leagues. The success I have found from using these tools has increased my win percentage from 47.8% in the 2022-2023 season to 70.3% in the 2023-2024 season. My rating has improved from 578 to 831, improving my managerial status ffrom bronze to platinum.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

### Prerequisites

This repository makes use of the `copy`, `random`, and `sys` Python libraries. 

### Using the solver

To use the solver, one first needs to convert clues given by the puzzle into rules (statements in propositional logic). We have not yet implemented an automated way to do this, so users will have to endure this tedious process (although we have provided an example puzzle in `example1.py`).

Once clues have been converted to propositional logic, create a new Python scrupt containing each Python file as a function, a list of those functions, and a list of lists representing the puzzle categories (again see `example1.py` for inspiration).

Finally, run `solver.py` from the command line. Input is given in the following order:
1. The maximum number of generations to run (an integer)
2. The size of the population (an integer)
3. The probability of crossover occuring (a floating-point number between 0.0 and 1.0)
4. The probability of mutation occuring (a floating-point number between 0.0 and 1.0)
6. The number of categories in the puzzle (an integer)
7. The number of items per category in the puzzle (an integer)
8. The index of which crossover method to use (in crossover_operators.py)
9. The index of which mutation method to use (in mutation_operators.py)
10. The number of rounds that occur in tournament selection (an integer)

Example: `python3 solver.py 500 100 0.30 0.01 4 5 0 2 4`

## Authors

* **Morgan Bauer**
* **Ramsay Flower**

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

* My grandfather for inspiring my competetive spirit
* The many books I have read about sports analytics
