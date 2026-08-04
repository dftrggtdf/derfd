def get_error(code):

    errors = {
        "ERR001": "Can't handle both operations, edit or cancel."
    }

    return f"{code}: {errors.get(code, 'Unknown error')}"