# Create by Joonsoo on Wednesday, April 20th, 2022
# @project desktop-bard
# @author Joonsoo
# This is take a file for specific process usage resources, like CPU and Memory

if ($null -eq $args[2]) {
    write-host "ERROR : Not enough parameters"
    write-host "Have to parameters : Process Name, Interval(sec) and Until(min)"
    exit 1
} else {
    $ProcessName = $args[0]
    $Interval = $args[1]
    $Until = $args[2]
}

# $CpuCores = (Get-WmiObject Win32_ComputerSystem).NumberOfLogicalProcessors
$CpuCores = (Get-CimInstance -ClassName Win32_ComputerSystem).NumberOfLogicalProcessors

write-host "===== Scouter Start !! (to CSV file) ====="
write-host "Process Name is $ProcessName"
write-host "Interval is $Interval"
write-host "Until is $Until"
write-host "How may cores $CpuCores"

while( $Counter -lt ($Until * 60) ) {
    if ($null -eq $Counter) {
        write-host "This is first time ... sleep $Interval(s)"
        Start-Sleep -Seconds $Interval
    }

    Get-Process $ProcessName | Select-Object name, @{Name="CPU(%)"; Expression={[Decimal]::Round((((Get-Counter "\Process($Processname*)\% Processor Time").CounterSamples.cookedvalue)/$CpuCores), 2)}}, @{Name="Memory(MB)"; Expression={[Decimal]::Round((((get-counter -Counter  "\Process($ProcessName)\Working Set - Private").CounterSamples.CookedValue)/1mb), 2)}} | Export-Csv -Path ./output.csv -append
    Start-sleep -Seconds $Interval
    $Counter = ($Counter + $Interval)
    write-host $Counter "/" ($Until*60) "sec"
}

write-host "DONE"