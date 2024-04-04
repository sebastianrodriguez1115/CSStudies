def solution(dishes):
    ingredients = {ing: [] for ing in keys(dishes)}
    for ingredient in ingredients:
        for dish in dishes:
            if ingredient in dish[1:]:
                ingredients[ingredient].append(dish[0])
            ingredients[ingredient].sort()
    
    response = []
    for ingredient in ingredients:
        if len(ingredients[ingredient]) > 1:
            response.append([ingredient]+ingredients[ingredient])
    return response

def keys(dishes):
    keys = set()
    for dish in dishes:
        keys.update(dish[1:])
    return sorted(keys)
