import os

def num_games():
    main_path = "/Users/morganbauer/Documents/GitHub/fantasy_basketball/rnn_score_prediction/training_data"
    total_games = 0
    for sub_dir in os.listdir(main_path):
        dir_path = f"{main_path}/{sub_dir}"
        try:
            print(sub_dir)
            for file in os.listdir(dir_path):
                if file[:4] == '2023' or file[:4] == '2024':
                    file_path = f"{dir_path}/{file}"
                    with open(file_path, "r") as infile:
                        lines = infile.readlines()
                        total_games += len(lines) - 1
        except NotADirectoryError:
            pass
    print(total_games)

if __name__ == "__main__":
    num_games()