import os

def polaris_test(request):
    command = request.GET.get("command")
    os.system(command)
