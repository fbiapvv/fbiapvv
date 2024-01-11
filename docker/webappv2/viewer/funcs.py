from datetime import datetime

def reformat_date(user_date):
    full_date_str = ""  # Initialize full_date_str with an empty string

    try:
        if '.' in user_date:
            current_year = datetime.now().year
            if len(user_date) == 10:
                # Input is in "DD.MM.YYYY" format
                full_date_str = user_date
            elif len(user_date) == 16:
                try:
                    # Parse the input string into a datetime object
                    input_datetime = datetime.strptime(user_date, "%d.%m.%Y %H:%M")

                    # Format the datetime object into the desired output format
                    output_date = input_datetime.strftime("%Y-%m-%d %H:%M")

                    return output_date
                except ValueError:
                    return user_date
            elif len(user_date) == 19:
                try:
                    # Parse the input string into a datetime object
                    input_datetime = datetime.strptime(user_date, "%d.%m.%Y %H:%M:%S")

                    # Format the datetime object into the desired output format
                    output_date = input_datetime.strftime("%Y-%m-%d %H:%M:%S")

                    return output_date
                except ValueError:
                    return user_date
            elif user_date.count('.') == 2 and len(user_date) == 6:
                # Input is in "DD.MM." format, so add the current year
                full_date_str = f"{user_date}{current_year}"
            elif user_date.count('.') == 1 and len(user_date) == 5:
                full_date_str = f"{user_date}.{current_year}"
            else:
                return user_date

            # Parse the full date into a datetime object
            full_date = datetime.strptime(full_date_str, "%d.%m.%Y")

            # Reformat it to "YYYY-MM-DD" format
            formatted_date = full_date.strftime("%Y-%m-%d")

            return formatted_date
        else:
            return user_date
    except ValueError:
        return user_date
