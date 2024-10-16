# Solving Logic Puzzles with Evolutionary Computation

We use techniques from evolutionary computation to solve logic grid puzzles. This is the final project for CS470 at Eckerd College, Spring 2024. To do this, we have recast this problem from a constraint satisfaction problem to a constraint optimization problem by specifying an objective function that quantifies constraints that are not satisfied. Each constraint comes from a clue given by the puzzle.

Evolutionary computation approximates an optimal solution via a process modelled after Darwinian evolution. Solutions are represented as *individuals* within a *population*. Initially, the population is initialized with a given number of pseudo-randomly generated individuals. A *fitness function* is defined to evaluate the strength of each individual as a potential solution. The population then "evolves" over a specified amount a time, by probabilistically selecting individuals to *recombine* based on their fitness values. The *children* that result from this recombination operation then undergo *mutation* in an effort to promote "genetic diversity". In practice, recombination and mutation increase coverage of the search space. This process will continue until a termination criterion is met. Commonly, this is a maximum number of generations, but as in our case, may also be the occurrence of a solution with a satisfactory fitness value.

Appropriate choice and design of data structures is one of the most crucial components of a successful evolutionary algorithm. To solve logic grid puzzles, we settled on a hybrid design that utilizes the properties of both a *permutation-based* representation and an *array-based* representation for the *genotype* of individuals. Specifically, individuals in our solution are represented as an array of permutations, where the length of the array is equal to the number of categories in the puzzle and the length of each permutation within the array is equal to the number of elements in each category (e.g. `[31425, 51243, 32415, 12345]`). The entries in each permutation indicate the correct row for the corresponding element.

Since the puzzle is solved by satisfying a set of given clues, an individual must satisfy all clues to represent a correct solution. Thus, we convert each clue into a set of corresponding propositional statements that we refer to as *rules*. Each clue in natural language may correspond to multiple rules. The fitness function is defined on the interval [0, 1] and the fitness of an individual that represents a correct solution is equal to 1.0.

Evolution of a population is driven by three operators: selection, recombination (also referred to as crossover), and mutation. First, two individuals are selected to serve as parents by some defined comparison of their respective fitness values. Then the two parents undergo recombination to produce two (sometimes one) children. Finally, the children are mutated and placed in a new generation. To select parents, we used an implementation of *tournament selection*. This operator represents the probability of choosing each parent for comparison from a given distribution. For simplicity, we use a uniform distribution rather than a weighted distribution based on the fitness values of each individual in the generation. The simplest implementation of tournament selection is binary tournament selection, in which two candidates are chosen from the given distribution. The fitness values of the two individuals are compared and the individual with the higher fitness is selected to be a parent. To increase selection pressure, we support an arbitrary number of rounds, and commonly use four rounds -- eight individuals are selected and compared in a pairs until there is only one individual remaining. Once two parents are selected, they must crossover. We use an implementation of *cycle crossover*, a recombination operator specifically used for evolutionary algorithms with a permutation representation for individuals. Cycle crossover is meant to prioritize the absolute order of entries in input permutations. Upon being returned, children must undergo mutation before populating a new generation. We primarily use *swap mutation* which randomly selects two entries in a permutation from a random distribution and exchanges them.

It is important to note that since our individual genotypes are represented as arrays of permutations, these operators must be applied to an individual in an element-wise manner. If the crossover operator is applied to two parents, then cycle crossover will be applied to each pair of permutations in the parent genotypes. However, for mutation, each permutation is treated independently, so one permutation in an individual may be mutated while another is not.

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

* Dr. Holger Mauch for teaching us about evolutionary computation
* My dad for having daily logic puzzle competitions with me
