param( [String]$header )

$location = Get-Location
$files = Get-ChildItem $location

<#
Checks if the first n letters of a file name
matches the header
#>
function goodHeader {
    param( [String]$fileName )

    $len = $header.Length
    if ( $header -eq $fileName.Substring( 0, $len ) ) {
        return $True
    }
    else {
        return $False
    }
}

<#
For all files that matches the header, and in the format of:
<header> <stuff> <date>,
then swap <stuff> and <date>.
#>
function main {

    foreach ( $file in $files ) {
        $fileName = $file.Basename
        
        if ( goodHeader( $fileName ) ) {
            $parts = $fileName.Substring( $header.Length ).trim().split()
            $part1 = $parts[0]
            $date = $parts[1]

            if ( $date -match "^\d+$" -and $parts.Length -eq 2 -and $date.Length -eq 8 ) {
                $month = [int]$date.Substring( 0, 2 )
                $day = [int]$date.Substring( 2, 2 )
                $year = [int]$date.Substring( 4 )

                if ( $month -le 12 -and $day -le 31 -and $year -ge 2000 -and $year -le 2099 ) {
                    $newName = $header + " " + $date + " " + $part1 + $file.Extension
                    $file | Rename-Item -NewName $newName
                }
            }
        }
    }
}
