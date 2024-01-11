from django.forms import ModelForm
from base.models import BeaconReaders, BeaconTags, VwReadtags

class BeaconReadersForm(ModelForm):
    class Meta:
        model = BeaconReaders
        fields = ['name', 'uid']

class BeaconTagsForm(ModelForm):
    class Meta:
        model = BeaconTags
        fields = ['name', 'uid', 'active']

class VwReadtagsForm(ModelForm):
    class Meta:
        model = VwReadtags
        fields = ['read_datetime', 'tag_name']


