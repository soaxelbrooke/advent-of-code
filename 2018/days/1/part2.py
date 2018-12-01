
import sys

current_freq = 0
seen_freqs = set()

while True:
    with open('input.txt') as infile:
        for line in infile:
            current_freq = eval(f"{current_freq}{line.strip()}")
            if current_freq in seen_freqs:
                print(current_freq)
                sys.exit(0)
            else:
                seen_freqs.add(current_freq)
