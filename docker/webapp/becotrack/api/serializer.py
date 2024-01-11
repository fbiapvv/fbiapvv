from rest_framework import serializers
from base.models import BeaconReaders, BeaconTags, LoadedBeaconTags


class BeaconReaderserializer(serializers.ModelSerializer):
    class Meta:
        model = BeaconReaders
        fields = '__all__'


class BeaconTagserializer(serializers.ModelSerializer):
    class Meta:
        model = BeaconTags
        fields = '__all__'


class BeaconTagFromAutomaticserializer(serializers.ModelSerializer):
    tag_uid = serializers.CharField(source='uid')
    rssi = serializers.IntegerField(source='last_rssi')

    class Meta:
        model = BeaconTags
        fields = ['tag_uid', 'rssi', 'local_name', 'UUIDs', 'active']


class LoadedBeaconTagsserializer(serializers.ModelSerializer):

    def validate_tag_uid(self, value):
        """
        Check if the tag_uid exists in the BeaconTags model.
        """
        if not BeaconTags.objects.filter(uid=value).exists():
            raise serializers.ValidationError(
                "tag_uid does not exist in BeaconTags.")
        return value

    def is_valid(self, raise_exception=False):
        # Overriding is_valid to handle bulk inserts

        self._errors = []

        # If not a bulk insert, fall back to the default behavior
        if not isinstance(self.initial_data, list):
            return super().is_valid(raise_exception)

        is_valid = True

        for data in self.initial_data:
            serializer = LoadedBeaconTagsserializer(data=data)
            if not super(LoadedBeaconTagsserializer, serializer).is_valid(raise_exception):
                is_valid = False
                self._errors.append(serializer.errors)
            else:
                self._errors.append({})

        if not is_valid and raise_exception:
            raise serializers.ValidationError(self.errors)

        return is_valid

    class Meta:
        model = LoadedBeaconTags
        fields = '__all__'
