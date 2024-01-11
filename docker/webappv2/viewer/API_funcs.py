from django.core.exceptions import ObjectDoesNotExist, MultipleObjectsReturned
from .models import Chip, Calibration, Position, LoadedChip, Reader
from datetime import datetime
from collections import defaultdict
from django.utils import timezone


def create_chip_json(json_data):

    print(f"Local name of new chip: {json_data['pomenovanie']}")
    print(f"uid of new chip: {json_data['macAddress']}")
    print(f"UUIDs of new chip: {json_data['proximityUUID']}")
    print(f"major: {json_data['major']}")
    print(f"minor: {json_data['minor']}")
    print(f"accuracy: {json_data['accuracy']}")
    print(f"proximity: {json_data['proximity']}")
    print(f"txPower: {json_data['txPower']}")

    try:
        existing_chip = Chip.objects.get(uid=json_data['macAddress'])
        existing_chip.name = json_data['pomenovanie']
        existing_chip.modified = datetime.now()
        existing_chip.save()
        print(
            f"Chip with uid {existing_chip.uid} has been updated to {json_data['pomenovanie']}")

    except Chip.DoesNotExist:
        chip = Chip.objects.create(
            name=json_data['pomenovanie'],
            uid=json_data['macAddress'],
            UUIDs=json_data['proximityUUID'],
            minor=json_data['minor'],
            major=json_data['major'],
            proximity=json_data['proximity'],
            accuracy=json_data['accuracy'],
            tx_power=json_data['txPower'],
            created=datetime.now(),
            modified=datetime.now()
        )
        chip.save()
        print(f"New chip {json_data['pomenovanie']} created.")


def create_calibration_json(json_data):

    print(f"Uid of chip {json_data['macAddress']}")
    print(f"Position: {json_data['pozicia']}")

    date_time_from_str = json_data['cas_start']
    date_time_to_str = json_data['cas_stop']

    # Parse ISO-formatted datetime strings into datetime objects
    date_time_from = datetime.fromisoformat(date_time_from_str)
    date_time_to = datetime.fromisoformat(date_time_to_str)
    print(f"DateTime from: {date_time_from}")
    print(f"DateTime to: {date_time_to}")

    try:
        chip = Chip.objects.get(uid=json_data['macAddress'])
        position = Position.objects.get(name=json_data['pozicia'])

        try:
            existing_calibration = Calibration.objects.get(
                chip=chip, position=position)
            existing_calibration.datetime_from = date_time_from
            existing_calibration.datetime_to = date_time_to
            existing_calibration.modified = datetime.now()
            existing_calibration.save()

        except Calibration.DoesNotExist:
            # Create a new Calibration if it doesn't exist for this Chip and Position
            Calibration.objects.create(
                chip=chip,
                position=position,
                datetime_from=date_time_from,
                datetime_to=date_time_to,
                created=datetime.now(),
                modified=datetime.now()
            )

        except MultipleObjectsReturned:
            # Handle the case where multiple calibrations were found

            oldest_calibration = Calibration.objects.filter(
                chip=chip, position=position).order_by('created').first()

            oldest_calibration.datetime_from = date_time_from
            oldest_calibration.datetime_to = date_time_to
            oldest_calibration.modified = datetime.now()

            oldest_calibration.save()
            Calibration.objects.filter(chip=chip, position=position).exclude(
                id=oldest_calibration.id).delete()

    except ObjectDoesNotExist:
        pass


def send_number_of_found_readers(request):
    MAC_address = request.GET.get('macAddress')
    print(f"Uid of chip {MAC_address}")

    date_time_from_str = request.GET.get('cas_start')
    date_time_to_str = request.GET.get('cas_teraz')

    # Define the format of the datetime strings
    date_format = "%Y-%m-%dT%H:%M:%S.%f"

    # Parse the datetime strings into datetime objects
    date_time_from = datetime.strptime(date_time_from_str, date_format)
    date_time_to = datetime.strptime(date_time_to_str, date_format)
    print(f"DateTime from: {date_time_from}")
    print(f"DateTime to: {date_time_to}")

    # Query all Reader objects
    all_readers = Reader.objects.all()

    # Initialize a dictionary to store reader counts
    reader_counts = {reader.name: 0 for reader in all_readers}

    # Filter LoadedChips for the specified MAC_address and date range
    loaded_chips = LoadedChip.objects.filter(
        read_datetime__range=(date_time_from, date_time_to),
        tag_uid=MAC_address
    )

    # Count LoadedChips for each reader
    for chip in loaded_chips:
        reader = Reader.objects.get(uid=chip.reader_uid)
        reader_counts[reader.name] += 1

    # Create JSON data
    json_data = {
        'count': 0,
        'reader_counters': [
            {
                'reader_name': reader_name,
                'reader_count': count
            }
            for reader_name, count in reader_counts.items()
        ]
    }

    print(json_data)

    return json_data
