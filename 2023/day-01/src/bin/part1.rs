// Advent of Code 2023 - Day 1 - Part 1
// Author: Noah Grant

// Code taken from: https://youtu.be/JOgQMjpGum0?si=EfbKBDNYHfcNa_Fm

fn main() {
    let input = include_str!("./input2.txt");
    let output = part1(input);
    dbg!(output);
}

fn part1(input: &str) -> String {
    let output = input
        .lines() // Iterate over each line in input (ends on \n)
        .map(|line| {
            // Convert string -> chars
            let mut numbers = line
                .chars() // Iterate over each char
                .filter_map(|character| {
                    // Filter each char and convert char -> int
                    character.to_digit(10) // Return int if the the char was 0-9
                });

            let first_num = numbers.next().expect("Should be a number");
            let last_num = numbers.last(); // Will either return Some or None

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
        let result = part1(
            "1abc2
pqr3stu8vwx
a1b2c3d4e5f
treb7uchet",
        );
        assert_eq!(result, "142");
    }
}
