import json
from django.http import JsonResponse
from django.shortcuts import render
from rest_framework.decorators import api_view
from .API_funcs import create_chip_json, create_calibration_json, send_number_of_found_readers
from .models import Chip, Position, Calibration, LoadedChip, Reader
from rest_framework.response import Response
from django.db.models import Q
from django.middleware.csrf import get_token
from datetime import datetime
from django.core.paginator import Paginator, EmptyPage, PageNotAnInteger
from .forms import LoadedChipsSearchForm
from .funcs import reformat_date


###################################### templates + JSON data       ####################################

def chip_list(request):
    all_chips = Chip.objects.all()
    json_chips_data = [
        {
            'id': str(chip.id),
            'name': str(chip.name),
            'uid': str(chip.uid),
            'active': str(chip.active),
            'UUIDs': str(chip.UUIDs),
            'local_name': str(chip.local_name),
            'proximity': str(chip.proximity),
            'accuracy': str(chip.accuracy),
            'minor': str(chip.minor),
            'major': str(chip.major),
            'tx_power': str(chip.tx_power)
        }
        for chip in all_chips
    ]

    context = {
        'all_chips': all_chips,
        'json_chips_data': json_chips_data
    }
    return render(request, 'chip_list.html', context)


def calibration_list(request):
    all_calibrations = Calibration.objects.all()
    json_calibration_data = [
        {
            'id': str(calibration.id),
            'chip': str(calibration.chip.name),
            'position': str(calibration.position.name),
            'from': calibration.datetime_from.isoformat() if calibration.datetime_from else "None",
            'to': calibration.datetime_to.isoformat() if calibration.datetime_to else "None",
            'created': calibration.created.isoformat() if calibration.created else "None",
            'modified': calibration.modified.isoformat() if calibration.modified else "None",
        }
        for calibration in all_calibrations
    ]

    json_chip_names = [{'id': chip.id, 'name': str(
        chip.name)} for chip in Chip.objects.all()]
    json_positions = [{'id': position.id, 'name': str(
        position.name)} for position in Position.objects.all()]

    context = {
        'all_calibrations': all_calibrations,
        'json_calibration_data': json_calibration_data,
        'json_chip_names': json_chip_names,
        'json_positions': json_positions
    }
    return render(request, 'calibration_list.html', context)


def positions(request):
    all_positions = Position.objects.all()
    json_position_data = [
        {
            'id': str(position.id),
            'name': str(position.name),
            'active': str(position.active),
            'created': position.created.isoformat() if position.created else "None",
            'modified': position.modified.isoformat() if position.modified else "None",
        }
        for position in all_positions
    ]

    context = {
        'all_positions': all_positions,
        'json_position_data': json_position_data
    }
    return render(request, 'positions.html', context)


def loaded_chips_list(request):
    form = LoadedChipsSearchForm(request.GET)
    all_loaded_chips = LoadedChip.objects.all().order_by('-read_datetime')

    reader_name = None
    chip_name = None
    rssi = None
    read_datetime = None
    created = None
    modified = None

    if form.is_valid():
        # Filter the queryset based on user input
        reader_name = form.cleaned_data.get('reader_name')
        chip_name = form.cleaned_data.get('chip_name')
        rssi = form.cleaned_data.get('rssi')
        read_datetime = reformat_date(form.cleaned_data.get('read_datetime'))
        created = reformat_date(form.cleaned_data.get('created'))
        modified = reformat_date(form.cleaned_data.get('modified'))

        if reader_name:
            reader_objects = Reader.objects.filter(name__icontains=reader_name)
            reader_uids = [reader.uid for reader in reader_objects]
            all_loaded_chips = all_loaded_chips.filter(
                reader_uid__in=reader_uids)
        if chip_name:
            chip_objects = Chip.objects.filter(name__icontains=chip_name)
            chip_uids = [chip.uid for chip in chip_objects]
            all_loaded_chips = all_loaded_chips.filter(tag_uid__in=chip_uids)
        if rssi:
            all_loaded_chips = all_loaded_chips.filter(rssi__icontains=rssi)
        if read_datetime:
            all_loaded_chips = all_loaded_chips.filter(
                read_datetime__icontains=read_datetime)
        if created:
            all_loaded_chips = all_loaded_chips.filter(
                created__icontains=created)
        if modified:
            all_loaded_chips = all_loaded_chips.filter(
                modified__icontains=modified)

    filter_parameters = {
        'reader_name': reader_name,
        'chip_name': chip_name,
        'rssi': rssi,
        'read_datetime': read_datetime,
        'created': created,
        'modified': modified
    }

    paginator = Paginator(all_loaded_chips, 100)  # Set 100 items per page

    page = request.GET.get('page')
    try:
        loaded_chips = paginator.page(page)
    except PageNotAnInteger:
        # If the page parameter is not an integer, show the first page
        loaded_chips = paginator.page(1)
    except EmptyPage:
        # If the page is out of range, show the last page
        loaded_chips = paginator.page(paginator.num_pages)

    chip_names_uids = {
        chip.uid.lower(): chip.name for chip in Chip.objects.all()}
    reader_names_uids = {
        reader.uid.lower(): reader.name for reader in Reader.objects.all()}

    loaded_chips_data = []
    for chip in loaded_chips:
        loaded_chips_data.append({
            'reader_name': reader_names_uids.get(chip.reader_uid.lower(), chip.reader_uid.lower()),
            'tag_name': chip_names_uids.get(chip.tag_uid.lower(), chip.tag_uid.lower()),
            'rssi': chip.rssi,
            'read_datetime': chip.read_datetime if chip.read_datetime else "None",
            'created': chip.created if chip.created else "None",
            'modified': chip.modified if chip.modified else "None",
            'active': "1" if chip.active else "0"
        })

    context = {
        'loaded_chips': loaded_chips,
        'loaded_chips_data': loaded_chips_data,
        'form': form,
        'filter_parameters': filter_parameters
    }
    return render(request, 'loaded_chips.html', context)


def readers(request):
    all_readers = Reader.objects.all()
    json_readers_data = [
        {
            'id': str(reader.id),
            'name': str(reader.name),
            'uid': str(reader.uid),
            'active': str(reader.active),
            'last_connected': reader.last_connected.isoformat() if reader.last_connected else "None",
            'created': reader.created.isoformat() if reader.created else "None",
            'modified': reader.modified.isoformat() if reader.modified else "None",
        }
        for reader in all_readers
    ]

    context = {
        'all_readers': all_readers,
        'json_readers_data': json_readers_data
    }
    return render(request, 'readers.html', context)


###################################### Chip CRUD       ####################################

def delete_chip(request, chip_id):
    if request.method == 'DELETE':
        chip = Chip.objects.get(id=chip_id)
        print(f"Chip {chip.name} deleted.")
        chip.delete()
        return JsonResponse({"status": "success"})
    return JsonResponse({"status": "error"})


def update_chip(request):
    if request.method == 'POST':
        request_data = json.loads(request.body)

        chip = Chip.objects.get(id=request_data['chipId'])

        if Chip.objects.filter(name=request_data['name']).exclude(id=chip.id).exists():
            return JsonResponse({'success': False, 'message': f'Čip s názvom {request_data["name"]} už existuje.'})
        else:
            chip.name = request_data['name']
            chip.local_name = request_data['local_name']
            chip.UUIDs = request_data['UUIDs']
            chip.proximity = request_data['proximity']
            chip.accuracy = request_data['accuracy'] if request_data['accuracy'] != '' else None
            chip.minor = request_data['minor'] if request_data['minor'] != '' else None
            chip.major = request_data['major'] if request_data['major'] != '' else None
            chip.tx_power = request_data['tx_power'] if request_data['tx_power'] != '' else None
            chip.active = request_data['active']
            chip.modified = datetime.now()

            chip.save()
            print(f"Chip {chip.name} updated.")

            return JsonResponse({"status": "success"})
    return JsonResponse({"status": "error"})


def create_new_chip(request):
    if request.method == 'POST':
        request_data = json.loads(request.body)

        if Chip.objects.filter(name=request_data['name']).exists():
            return JsonResponse({'success': False, 'message': f'Čip s menom {request_data["name"]} už existuje.'})
        else:
            chip = Chip.objects.create(
                name=request_data['name'],
                local_name=request_data['local_name'],
                uid=request_data['uid'],
                UUIDs=request_data['UUIDs'],
                proximity=request_data['proximity'],
                tx_power=request_data['tx_power'],
                created=datetime.now(),
                modified=datetime.now()
            )

            if 'minor' in request_data and request_data['minor']:
                chip.minor = request_data['minor']

            if 'major' in request_data and request_data['major']:
                chip.major = request_data['major']

            if 'accuracy' in request_data and request_data['accuracy']:
                chip.accuracy = request_data['accuracy']

            chip.save()
            print(f"Chip {chip.name} created.")
            return JsonResponse({"success": True})
    return JsonResponse({"success": False, "message": "Invalid request method"})


###################################### Calibration CRUD       ####################################


def create_new_calibration(request):
    if request.method == 'POST':
        request_data = json.loads(request.body)

        chip = Chip.objects.get(id=int(request_data['chipId']))
        position = Position.objects.get(id=int(request_data['positionId']))

        new_cal = Calibration.objects.create(
            chip=chip,
            position=position,
            datetime_from=request_data['datetimeFrom'],
            datetime_to=request_data['datetimeTo'],
            created=datetime.now(),
            modified=datetime.now()
        )
        new_cal.save()

        print(f"New calibration for {chip.name} created.")
        return JsonResponse({'status': 'success'})
    return JsonResponse({'status': 'error'})


def update_calibration(request):
    if request.method == 'POST':
        request_data = json.loads(request.body)

        calibration = Calibration.objects.get(id=request_data['calibrationId'])
        chip = Chip.objects.get(id=request_data['chipId'])
        position = Position.objects.get(id=request_data['positionId'])

        calibration.chip = chip
        calibration.position = position
        calibration.datetime_from = request_data['datetimeFrom']
        calibration.datetime_to = request_data['datetimeTo']
        calibration.modified = datetime.now()
        calibration.save()
        print(f"Calibration {calibration.id} updated.")

        return JsonResponse({"status": "success"})
    return JsonResponse({"status": "error"})


def delete_calibration_server(request, calibration_id):
    if request.method == 'DELETE':
        calibration = Calibration.objects.get(id=calibration_id)
        print(f"Calibration {calibration.id} deleted.")
        calibration.delete()
        return JsonResponse({"status": "success"})
    return JsonResponse({"status": "error"})


###################################### Position CRUD       ####################################


def update_position(request):
    if request.method == 'POST':
        request_data = json.loads(request.body)

        position = Position.objects.get(id=request_data['positionId'])
        position.name = request_data['name']
        position.active = request_data['active']
        position.modified = datetime.now()
        position.save()
        return JsonResponse({"status": "success"})
    return JsonResponse({"status": "error"})


def delete_position(request, position_id):
    if request.method == 'DELETE':
        position = Position.objects.get(id=position_id)
        print(f"Position {position.name} deleted.")
        position.delete()
        return JsonResponse({"status": "success"})
    return JsonResponse({"status": "error"})


def create_new_position(request):
    if request.method == 'POST':
        request_data = json.loads(request.body)

        if Position.objects.filter(name=request_data['name']).exists():
            return JsonResponse({'success': False, 'message': f'Pozícia {request_data["name"]} už existuje.'})
        else:
            new_position = Position.objects.create(
                name=request_data['name'],
                active=request_data['active'],
                created=datetime.now(),
                modified=datetime.now()
            )
            new_position.save()

            print(f"New position {new_position.name} created.")
            return JsonResponse({"success": True})
    return JsonResponse({'status': 'error'})


###################################### Reader    ####################################


def update_reader(request):
    if request.method == 'POST':
        request_data = json.loads(request.body)

        reader = Reader.objects.get(id=request_data['readerId'])
        if Reader.objects.filter(name=request_data['name']).exclude(id=reader.id).exists():
            return JsonResponse({'success': False, 'message': f'Čítačka s názvom {request_data["name"]} už existuje.'})
        else:
            reader.name = request_data['name']
            reader.modified = datetime.now()
            reader.save()
            print(f"Reader {reader.name} updated.")

        return JsonResponse({"success": True})
    return JsonResponse({'status': 'error'})


############################################ API views ########################################


@api_view(['GET'])
def get_csrf_token(request):
    token = get_token(request)
    return JsonResponse({'csrf_token': token})


@api_view(['POST'])
def create_chip_flutter(request):
    if request.method == 'POST':
        create_chip_json(request.data)
        print("Api view executed successfully.")
        return JsonResponse({'status': 'success'})
    return JsonResponse({'status': 'error'})


@api_view(['POST'])
def create_calibration_flutter(request):
    if request.method == 'POST':
        create_calibration_json(request.data)
        print("Api view executed successfully.")
        return JsonResponse({'status': 'success'})
    return JsonResponse({'status': 'error'})


@api_view(['GET'])
def get_chip_list(request):
    if request.method == 'GET':
        info = request.GET.get('info', '')
        if info == "get_all_chips":
            chips = Chip.objects.filter(active=True)
            json_data = [
                {
                    'pomenovanie': chip.name,
                    'macAddress': chip.uid,
                    'proximityUUID': chip.UUIDs,
                    'minor': chip.minor,
                    'major': chip.major,
                    'accuracy': chip.accuracy,
                    'proximity': chip.proximity,
                    'txPower': chip.tx_power
                }
                for chip in chips
            ]
            return Response(json_data)
        else:
            return Response({"error": "Invalid request"})


@api_view(['GET'])
def get_position_list(request):
    if request.method == 'GET':
        info = request.GET.get('info', '')
        if info == "get_positions":
            uid = request.GET.get('macAddress', '')
            chip = Chip.objects.get(uid=uid)
            already_done_calibrations = Calibration.objects.filter(chip=chip)
            positions_to_send = Position.objects.exclude(
                Q(calibration__in=already_done_calibrations) & Q(
                    calibration__chip=chip)
            )

            json_data = [{'name': position.name}
                         for position in positions_to_send]

            return Response(json_data)
        else:
            return Response({"error": "Invalid request"})


@api_view(['GET'])
def get_calibration_list(request):
    if request.method == 'GET':
        chip_uid = request.GET.get('macAddress', '')

        try:
            chip = Chip.objects.get(uid=chip_uid)
            calibrations_for_this_chip = Calibration.objects.filter(chip=chip)

            json_data = [
                {
                    'id': calibration.id,
                    'macAddress': calibration.chip.uid,
                    'position': calibration.position.name,
                    'datetime_from': calibration.datetime_from,
                    'datetime_to': calibration.datetime_to
                }
                for calibration in calibrations_for_this_chip
            ]
            return Response(json_data)
        except Chip.DoesNotExist:
            # Handle the case where the Chip doesn't exist
            return Response({'error': 'Chip with the specified macAddress not found'}, status=404)


@api_view(['DELETE'])
def delete_calibration(request):
    if request.method == 'DELETE':
        try:
            calibration_id = request.GET.get('id', '')
            cal = Calibration.objects.get(id=calibration_id)
            print(
                f"Calibration for chip {cal.chip.local_name} with position {cal.position.name} deleted")
            cal.delete()
            return JsonResponse({'status': 'success'})
        except Calibration.DoesNotExist:
            return JsonResponse({'status': 'error', 'message': 'Calibration not found'})


@api_view(['GET'])
def ongoing_calibration(request):
    if request.method == 'GET':
        result = send_number_of_found_readers(request)
        return Response(result)
    return JsonResponse({'status': 'error'})


@api_view(['POST'])
def while_ongoing_calibration_cancel(request):
    if request == 'POST':
        pass
        return JsonResponse({'status': 'success'})
    return JsonResponse({'status': 'error'})
