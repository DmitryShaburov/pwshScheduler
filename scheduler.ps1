$apiUrl = 'http://localhost:8001/api/v1'
$scheduler = 'pwshScheduler'

while ($true) {
    $pods = Invoke-RestMethod "$apiUrl/pods?fieldSelector=spec.nodeName="
    if ($pods.items.Count -gt 0) {
        $nodes = Invoke-RestMethod "$apiUrl/nodes"
        foreach ($pod in $pods.items) {
            if ($pod.spec.schedulerName -eq $scheduler) {
                Write-Host "Schedule pod: $($pod.metadata.name)"
                $node = Get-Random -InputObject $nodes.items -Count 1
                $binding = @{
                    apiVersion = "v1"
                    kind       = "Binding"
                    metadata   = @{
                        name = $pod.metadata.name
                    }
                    target     = @{
                        apiVersion = "v1"
                        kind       = "Node"
                        name       = $node.metadata.name
                    }
                } | ConvertTo-Json
                Invoke-RestMethod  -Method Post -ContentType 'application/json' -Body $binding `
                    -Uri "$apiUrl/namespaces/$($pod.metadata.namespace)/pods/$($pod.metadata.name)/binding"
            }
        }
    }
    Start-Sleep 10
}
