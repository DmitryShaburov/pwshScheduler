Kubernetes PowerShell scheduler
============

Inspired by [bashScheduler](https://github.com/rothgar/bashScheduler)

## How to run it 

Obviously not in production

Only runs on kubectl proxy api

Run nginx deployment that uses pwshScheduler

```
kubectl apply -f nginx-pwsh-scheduler.yml
```

You will see two nginx-pwsh-scheduler pods with Pending status

```
NAME                                    READY   STATUS    RESTARTS   AGE
nginx-pwsh-scheduler-84948c8d4f-9crz6   0/1     Pending   0          3s
nginx-pwsh-scheduler-84948c8d4f-njbhn   0/1     Pending   0          3s
```

Then proxy your localhost to the kubernetes api server

```
kubectl proxy
Starting to serve on 127.0.0.1:8001
```

Now in a powershell run scheduler

```
.\scheduler.ps1
```

In case you are now allowed to run scripts, modify ExecutionPolicy
```
Set-ExecutionPolicy -ExecutionPolicy Unrestricted
```

You will see that pods are scheduled to nodes
```
$ ./scheduler.sh
Schedule pod: nginx-pwsh-scheduler-84948c8d4f-9crz6
kind       : Status
apiVersion : v1
metadata   :
status     : Success
code       : 201

Schedule pod: nginx-pwsh-scheduler-84948c8d4f-njbhn
kind       : Status
apiVersion : v1
metadata   :
status     : Success
code       : 201
```

Now pods are scheduled to random nodes
```
NAME                                    READY   STATUS    RESTARTS   AGE
nginx-pwsh-scheduler-84948c8d4f-9crz6   1/1     Running   0          8m37s
nginx-pwsh-scheduler-84948c8d4f-njbhn   1/1     Running   0          8m37s
```