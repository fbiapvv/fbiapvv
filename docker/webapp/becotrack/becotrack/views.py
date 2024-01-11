from django.shortcuts import render, redirect
# from .models import BeaconReaders
# from .forms import BeaconReadersForm

# Create your views here.

def index(request):  
    return render(request,"index.html")  