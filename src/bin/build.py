#!/usr/bin/env python3

from utils import build_documents, copy_directory, Temperature, set_temperature_unit
from os.path import isdir, join
from os import mkdir
from sys import exit, argv
from argparse import ArgumentParser

if __name__ == '__main__':
    parser = ArgumentParser(description='Create and/or edit config files')
    parser.add_argument('source', type=str, help='Input source directory, e.g., \'src\'')
    parser.add_argument('destination', type=str, help='Build destination, e.g., \'builds\'')
    parser.add_argument('-t', '--temperature', help='Set temperature', choices=['imperial', 'si'], default='imperial')

    args = parser.parse_args()
    
    try:
        build_source, build_destination = args.source, args.destination
        if args.temperature == 'imperial':
            set_temperature_unit(Temperature.Imperial)
        else:
            set_temperature_unit(Temperature.SI)
    except Exception as e:
        print(e)
        exit(1)

    equipment_source_directory = join(build_source, 'config', 'equipment')
    ingredient_source_directory = join(build_source, 'config', 'ingredients')
    recipe_source_directory = join(build_source, 'config', 'recipes')
    book_dir = join(build_destination, 'book')
    if not isdir(build_destination):
        mkdir(build_destination)
        copy_directory(join(build_source, 'book'), book_dir)

    recipe_sections = [
        'basics',
        'cocktails',
        'coffee',
        'desserts',
        'main-course'
    ]


    build_documents('equipment', equipment_source_directory, book_dir)
    build_documents('ingredient', ingredient_source_directory, book_dir)

    for section in recipe_sections:
        recipe_source = join(recipe_source_directory, section)
        build_documents('recipe', recipe_source, join(book_dir, 'recipes'))
