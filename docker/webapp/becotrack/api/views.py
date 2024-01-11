from rest_framework.response import Response
from rest_framework.decorators import api_view
from base.models import BeaconReaders, LoadedBeaconTags, BeaconTags
from .serializer import BeaconReaderserializer, LoadedBeaconTagsserializer, BeaconTagFromAutomaticserializer
from django.utils import timezone
import json


@api_view(['GET'])
def getBeaconReadersData(request):
    items = BeaconReaders.objects.all()
    serializer = BeaconReaderserializer(items, many=True)
    return Response(serializer.data)


@api_view(['POST'])
def putBeaconReadersDataAdd(request):
    # obj =  BeaconReaders.objects.filter(uid=request.data["uid"])
    isUpdated = BeaconReaders.objects.filter(
        uid=request.data["uid"]).update(last_connected=timezone.now())
    serializer = None
    if isUpdated == 0:
        print(request.data)
        request.data["last_connected"] = timezone.now()
        serializer = BeaconReaderserializer(data=request.data)
        print(request.data)

        if serializer.is_valid():
            serializer.save()

    return Response(serializer.data if serializer != None else "Updated")


@api_view(['POST'])
def putLoadedBeaconTags(request):
    try:

        valid_entries = []  # Zoznam platných záznamov
        errors = []  # Zoznam chýb

        # Prechádzame cez každý riadok dát
        for item in request.data:
            serializer = LoadedBeaconTagsserializer(data=item)

            if serializer.is_valid():
                valid_entries.append(serializer.validated_data)
            else:
                errors.append(serializer.errors)

        # Uložíme všetky platné riadky
        for entry in valid_entries:
            LoadedBeaconTags.objects.create(**entry)

        # Tu môžete spracovať chyby (ak sú nejaké)
        if errors:
            # Odpovedajte s chybami alebo inak ich spracujte
            print(errors)

    except:
        None

    added = 0
    modified = 0
    # for _dt in request.data:
    #     isUpdated = 0
    #     objects = BeaconTags.objects.filter(uid=_dt["tag_uid"])

    #     for obj in objects:
    #         if obj != None:
    #             isUpdated = 1
    #             obj.local_name = _dt["local_name"]
    #             obj.last_rssi = _dt["rssi"]
    #             obj.read_datetime = timezone.now()
    #             obj.save()

    #     serializer = None
    #     if isUpdated == 0:
    #         # print(_dt)
    #         _dt['active'] = 0
    #         serializer = BeaconTagFromAutomaticserializer(data=_dt)

    #         if serializer.is_valid():
    #             serializer.save()
    #         print(serializer.data)
    #         added += 1

    #     else:
    #         modified += 1

    resp = {}
    resp['code'] = "200"
    resp['added'] = added
    resp['modified'] = modified
    resp['message'] = "OK"

    return Response(resp)
