from django.shortcuts import render, redirect
from base.models import BeaconReaders, BeaconTags, VwReadtags, VwTagslastrssi
from .forms import BeaconReadersForm, BeaconTagsForm

# Create your views here.
# ------------ BeaconReaders

def BeaconReadersList(request):  
    BeaconReaderss = BeaconReaders.objects.all()  
    return render(request,"BeaconReaders-list.html",{'BeaconReaderss':BeaconReaderss})  

def BeaconReadersCreate(request):  
    if request.method == "POST":  
        form = BeaconReadersForm(request.POST)  
        if form.is_valid():  
            try:  
                form.save() 
                model = form.instance
                return redirect('BeaconReaders-list')  
            except:  
                pass  
    else:  
        form = BeaconReadersForm()  
    return render(request,'BeaconReaders-create.html',{'form':form})  

def BeaconReadersUpdate(request, id):  
    _BeaconReaders = BeaconReaders.objects.get(id=id)
    form = BeaconReadersForm(initial={'name': _BeaconReaders.name, 'uid': _BeaconReaders.uid, 'last_connected': _BeaconReaders.last_connected})
    if request.method == "POST":  
        form = BeaconReadersForm(request.POST, instance=_BeaconReaders)  
        if form.is_valid():  
            try:  
                form.save() 
                model = form.instance
                return redirect('BeaconReaders-list')  
            except Exception as e: 
                pass    
    return render(request,'BeaconReaders-update.html',{'form':form})  

def BeaconReadersDelete(request, id):
    BeaconReaders_ = BeaconReaders.objects.get(id=id)
    try:
        BeaconReaders_.delete()
    except:
        pass
    return redirect('BeaconReaders-list')


# ------------ BeaconTags

def BeaconTagsList(request):  
    _BeaconTagss = VwTagslastrssi.objects.all()
    
    return render(request,"BeaconTags-list.html",{'BeaconTagss':_BeaconTagss})  

def BeaconTagsCreate(request):  
    if request.method == "POST":  
        form = BeaconTagsForm(request.POST)  
        if form.is_valid():  
            try:  
                form.save() 
                model = form.instance
                return redirect('BeaconTags-list')  
            except:  
                pass  
    else:  
        form = BeaconTagsForm()  
    return render(request,'BeaconTags-create.html',{'form':form})  

def BeaconTagsUpdate(request, id):  
    _BeaconTags = BeaconTags.objects.get(id=id)
    form = BeaconTagsForm(initial={'name': _BeaconTags.name, 'uid': _BeaconTags.uid, 'active': _BeaconTags.active})
    if request.method == "POST":  
        form = BeaconTagsForm(request.POST, instance=_BeaconTags)  
        if form.is_valid():  
            try:  
                form.save() 
                model = form.instance
                return redirect('BeaconTags-list')  
            except Exception as e: 
                pass    
    return render(request,'BeaconTags-update.html',{'form':form})  

def BeaconTagsDelete(request, id):
    BeaconTags_ = BeaconTags.objects.get(id=id)
    try:
        BeaconTags_.delete()
    except:
        pass
    return redirect('BeaconTags-list')

def BeaconTagsDeleteAll(request):
    
    try:
        BeaconTags.objects.filter(active=0).delete()
    except:
        pass
    return redirect('BeaconTags-list')


# ------------ BeaconTags

def VwReadtagsList(request):  
    if request.method == "GET":  
        _tag_name = request.GET.get("tag_name") if request.GET.get("tag_name") != None else ''
        _reader_name = request.GET.get("reader_name") if request.GET.get("reader_name") != None else ''
        _read_datetime= request.GET.get("read_datetime") if request.GET.get("read_datetime") != None and request.GET.get("read_datetime") != "" else "1990-01-01 00:00:01" 
        _VwReadtagss = VwReadtags.objects.filter(tag_name__contains=_tag_name).filter(reader_name__contains=_reader_name).filter(read_datetime__gte=_read_datetime).order_by('-id')[:1000]
    else:
        _VwReadtagss = VwReadtags.objects.all().order_by('-id')[:1000]

    return render(request,"VwReadtags-list.html",{'VwReadtagss':_VwReadtagss, 'tag_name': _tag_name, 'reader_name': _reader_name, 'read_datetime': _read_datetime})  


