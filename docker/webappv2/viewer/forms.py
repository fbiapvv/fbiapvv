from django import forms

class LoadedChipsSearchForm(forms.Form):
    reader_name = forms.CharField(required=False, label='', widget=forms.TextInput(attrs={'placeholder': 'Čítačka'}))
    chip_name = forms.CharField(required=False, label='', widget=forms.TextInput(attrs={'placeholder': 'Čip'}))
    rssi = forms.IntegerField(required=False, label='', widget=forms.TextInput(attrs={'placeholder': 'RSSI'}))
    read_datetime = forms.CharField(required=False, label='', widget=forms.TextInput(attrs={'placeholder': 'Posledné načítanie'}))
    created = forms.CharField(required=False, label='', widget=forms.TextInput(attrs={'placeholder': 'Vytvorené'}))
    modified = forms.CharField(required=False, label='', widget=forms.TextInput(attrs={'placeholder': 'Upravené'}))