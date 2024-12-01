// Advent of Code 2023 - Day 1 - Part 2
// Author: Noah Grant

fn main() {
    let input = include_str!("./input2.txt");
    let output = part2(input);
    dbg!(output);
}

fn part2(input: &str) -> String {
    let spelt_numbers = [
        "one", "two", "three", "four", "five", "six", "seven", "eight", "nine",
    ];

    let output = input
        .lines()
        .map(|line| {
            let mut numbers = line.chars().filter_map(|character| {
                character.to_digit(10).or_else(|| {
                    let mut result = None;
                    for number in spelt_numbers {
                        let letters = number.chars();
                        let mut found = false;
                        let mut c = character;

                        for letter in letters {
                            if c != letter {
                                println!("{c} != {letter}");
                                found = false;
                                break;
                            } else {
                                println!("{c} == {letter}");
                                found = true;
                                match line.chars().next() {
                                    Some(l) => c = l,
                                    None => break,
                                }
                            }
                        }

                        if found == true {
                            println!("found: {number}");
                            result = Some(9);
                        }
                    }
                    result
                })
            });

            let first_num = numbers.next().expect("Should be a number in {line}");
            let last_num = numbers.last();

            match last_num {
                Some(num) => format!("{first_num}{num}").parse::<u32>(),
                None => format!("{first_num}{first_num}").parse::<u32>(),
            }
            .expect("Should be a valid number")
        })
        .sum::<u32>();

    output.to_string()
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn it_works() {
        let result = part2(
            "two1nine
eightwothree
abcone2threexyz
xtwone3four
4nineeightseven2
zoneight234
7pqrstsixteen",
        );
        assert_eq!(result, "281");
    }
}
