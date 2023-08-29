import os
import sys
import time
from random import random, choice

from tqdm import tqdm


def clear_terminal():
    if os.name == 'posix':
        os.system('clear')  # For Unix-like systems (Linux, macOS)
    else:
        os.system('cls')    # For Windows

def main():
    total_steps = 100
    phrases = get_phrase()
    while True:
        bar = tqdm(
                range(total_steps + 1), 
                desc="place holder", 
                ncols=100,
                colour="green",
                postfix="",
                bar_format = '{l_bar}{bar}|'
            )
        phrase = choice(phrases).strip()
        clear_terminal()
        bar.set_description(desc=phrase)
        try:
            for step in bar:
                time.sleep(random())  # Simulate some work being done
        except KeyboardInterrupt:
            sys.exit() 

        # bar.reset()

def get_phrase():
    with open(os.path.join(os.path.dirname(__file__), "phrases.txt")) as f:
        phrases = f.readlines()

    return phrases


if __name__ == "__main__":
    main()
