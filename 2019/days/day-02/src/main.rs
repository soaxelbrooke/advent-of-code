
#[macro_use] extern crate failure;

use std::io::prelude::*;
use failure::Error;

#[derive(Debug, Fail)]
enum ProgramError {
    #[fail(display = "Invalid Opcode provided: {}", opcode)]
    InvalidOpcode {
        opcode: usize
    },

    #[fail(display = "No solution found")]
    NoSolution
}

fn read_program() -> Result<Vec<usize>, Error> {
    let mut program = vec!();
    let mut stdin = std::io::stdin();
    let mut program_text = String::new();
    stdin.read_to_string(&mut program_text)?;

    for string in program_text.trim().split(",") {
        let number: usize = string.parse()?;
        program.push(number);
    }

    Ok(program)
}

fn modify_program_for_part_1(mut program: Vec<usize>) -> Vec<usize> {
    program[1] = 12;
    program[2] = 2;
    program
}

fn run_program(program: &mut Vec<usize>) -> Result<(), Error> {
    let mut current_position: usize = 0;

    loop {
        let current_op = program[current_position];
        if current_op == 99 {
            // Program has completed
            break;
        } else if current_op == 1 || current_op == 2 {
            let input_a_addr = program[current_position + 1];
            let input_b_addr = program[current_position + 2];
            let output_addr = program[current_position + 3];

            program[output_addr] = match current_op {
                1 => program[input_a_addr] + program[input_b_addr],
                2 => program[input_a_addr] * program[input_b_addr],
                _ => panic!("Only expected opcode 1 or 2"),
            };

            current_position += 4;
        } else {
            return Err(Error::from(ProgramError::InvalidOpcode { opcode: current_op }));
        }
    }

    Ok(())
}

fn part_2(base_program: Vec<usize>) -> Result<(usize, usize), Error> {
    for noun in 0..99 {
        for verb in 0..99 {
            let mut program = base_program.clone();
            program[1] = noun;
            program[2] = verb;
            run_program(&mut program)?;
            if program[0] == 19690720 {
                return Ok((noun, verb));
            }
        }
    }

    Err(Error::from(ProgramError::NoSolution))
}

fn main() {
    println!("Part 1:");
    let program = read_program().expect("Couldn't read program.");
    let part_1_program = program.clone();
    let mut part_1_program = modify_program_for_part_1(part_1_program);
    run_program(&mut part_1_program).expect("Failed to run program");
    println!("Solution: {}", part_1_program[0]);

    println!("Part 2:");
    let part_2_program = program.clone();
    let (noun, verb) = part_2(part_2_program).expect("Failed!");
    println!("Solution: {}", 100 * noun + verb);
}
