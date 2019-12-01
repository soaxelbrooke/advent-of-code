
use failure::Error;
use std::io::prelude::*;

fn read_input() -> Result<Vec<i64>, Error> {
    let stdin = std::io::stdin();
    let mut lines = vec![];
    for line in stdin.lock().lines() {
        let number: i64 = line?.parse()?;
        lines.push(number);
    }
    Ok(lines)
}

fn raw_feul_required(module_mass: &i64) -> i64 {
    return module_mass / 3 - 2;
}

fn feul_required(module_mass: &i64) -> i64 {
    let mut required = vec![raw_feul_required(module_mass)];

    while required.last().unwrap() > &6 {
        required.push(raw_feul_required(&required.last().unwrap()));
    }

    required.iter().fold(0, |sum, item| sum + item)
}

fn part_1_solution(module_masses: &Vec<i64>) -> i64 {
    return module_masses.iter().fold(0, |sum, module_mass| sum + raw_feul_required(&module_mass));
}

fn part_2_solution(module_masses: &Vec<i64>) -> i64 {
    return module_masses.iter().fold(0, |sum, module_mass| sum + feul_required(&module_mass));
}

fn main() {
    let module_masses = read_input().expect("No stdin provided");
    println!("Part 1 solution: {}", part_1_solution(&module_masses));
    println!("Part 2 solution: {}", part_2_solution(&module_masses));
}
