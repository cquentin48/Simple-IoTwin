import sys
import os
from typing import List

import json

def get_value(data:List[str], index:str) -> str:
    """
    From data linked to the board, retrieve the value linked to the given index.
    Otherwise a `KeyError` exception is raised.
    
    :param data: Board data (e.g. Name, CPU, Variant, ...)
    :param index: Value label index
    
    :return: Value if index is set
    """
    line = [input for input in data if input.startswith(index)]
    if len(line) == 0:
        raise KeyError(f"The label {index} isn't set for the board ${board}!")
    else:
        line = line[0]
    value = line.split('=')[1]
    return value

def get_board_data(board: str) -> List[str]:
    """
    From the board file, fetch data related to the board specified.
    If the board doesn't exist, a `KeyError` exception is raised.
    
    :param board: Arduino board chosen for the library to be built upon
    
    :return: Board related data
    """
    with open("build/_deps/arduinocore/boards.txt") as file:
        data = file.readlines()
    
    data = [line.replace('\n','') for line in data if line.startswith(f'{board}.')]
    
    if len(data) == 0:
        raise KeyError(f"The board {board} isn't set inside the family board!")
    else:
        return data

board = sys.argv[1]

try:
    data = get_board_data(board)
    data = {
        'boardName':get_value(data, f"{board}.name"),
        'mcu':get_value(data, f"{board}.build.mcu"),
        'f_cpu':get_value(data, f"{board}.build.f_cpu"),
        'variant':get_value(data, f"{board}.build.variant"),
    }
    print(json.dumps(data))
except KeyError as e:
    print(e)
    exit(1)