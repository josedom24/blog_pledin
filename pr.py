import json,subprocess,os
lista=["zithromax","Amie"]
a=subprocess.check_output(["gh","pr","list","--json","number"])
d=json.loads(a.decode('utf-8'))
for number in d:
    a=subprocess.check_output(["gh","pr","view",str(number.get("number")),"--json","body"])
    dd=json.loads(a.decode('utf-8'))
    for user in lista:
        if user in dd.get("body"):
            os.system("gh pr close -d "+str(number.get("number")))
            
