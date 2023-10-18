import requests

BASE_PATH = 'https://pokeapi.co/api/v2/pokemon/'


# Asking user input
print("Welcome to an ugly pokedex")
pokemon_name = input(
    'Enter the name of a pokemon and we will tell you more about it: '
)

# try to get a valid response from the API (right pokemon name)
# It will keep asking for a pokemon name if keeps failing.
response = requests.get(f'{BASE_PATH}/{pokemon_name}/')
while response.status_code != 200:
    pokemon_name = input('That pokemon does not exits. Enter the right name: ')
    response = requests.get(f'{BASE_PATH}/{pokemon_name}/')

pokemon_data = response.json()

# Parsing some lists with data to string
abilities = ', '.join(
    ability['ability']['name'] for ability in pokemon_data["abilities"]
)
moves = ', '.join(
    move['move']['name'] for move in pokemon_data["moves"]
)
types = ', '.join(
    the_type['type']['name'] for the_type in pokemon_data["types"]
)

# Displaying collected information
print(f'The name of this pokemon is {pokemon_data["name"]}')
print(f'It\'s base experience is {pokemon_data["base_experience"]}')
print(f'It\'s height is {pokemon_data["height"]} and weight is {pokemon_data["weight"]}')
print(f'It\'s abilities are: {abilities}')
print(f'It\'s moves are: {moves}')
print(f'It\'s types is (are): {types}')
