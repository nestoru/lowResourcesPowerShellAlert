# lowResourcesAlert.ps1
# @author: Nestor Urquiza
# @date: 20170104
# @description: Sends an email when any of the declared thresholds is reached

# Set your Thresholds
$cpuLoadPercentageThreshold = 0
$memoryUsedPercentageThreshold = 0
$diskUsedPercentageThreshold = 0

# Set your SMTP details
$SMTP_HOST = ""
$SMTP_FROM = "" 
$SMTP_TO = "" 

# Get current computer name
$computerName = $env:computername

# Get current CPU Load Percentage
$cpuLoadPercentageObject = Get-WmiObject win32_processor | Measure-Object -property LoadPercentage -Average | Select Average
$cpuLoadPercentage = $cpuLoadPercentageObject.Average
if($cpuLoadPercentage -ge $cpuLoadPercentageThreshold) {
  $subject = "[cpuLoadPercentage]"
  $result = "cpuLoadPercentage: $cpuLoadPercentage `r`n"
}

# Get current Memory Used Percentage
$memoryUsedPercentageObject = gwmi -Class win32_operatingsystem | Select-Object @{Name = "memoryUsedPercentage"; Expression = {"{0:N2}" -f ((($_.TotalVisibleMemorySize - $_.FreePhysicalMemory) / $_.TotalVisibleMemorySize) * 100)}}
$memoryUsedPercentage = $memoryUsedPercentageObject.memoryUsedPercentage
if($memoryUsedPercentage -ge $memoryUsedPercentageThreshold) {
  $subject += "[memoryUsedPercentage]"
  $result += "memoryUsedPercentage: $memoryUsedPercentage `r`n"
}

# Get current HDD Used Percentage
$disks = gwmi win32_logicaldisk -Filter "DriveType='3'" | Select-Object DeviceId, Size, FreeSpace
$disks | ForEach-Object {
  $diskUsedPercentage = (1 - $_.FreeSpace / $_.Size) * 100
  if($diskUsedPercentage -ge $diskUsedPercentageThreshold) {
    $subject += "[diskUsedPercentage " + $_.DeviceId + "]"
    $result += "diskUsedPercentage for drive " + $_.DeviceId + " $diskUsedPercentage `r`n"
  }
}

# Send email if needed
if($result) {
  $result = "$ComputerName matched resource(s):`r`n" + $result
  $subject = "$ComputerName threshold(s) matched: $subject"
  echo "subject: `r`n$subject"
  echo "result: `r`n$result"
  Send-MailMessage -smtpServer $SMTP_HOST -From $SMTP_FROM -To $SMTP_TO -Subject $subject -Body $result
}
