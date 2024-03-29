
$location = Get-Location
$files = Get-ChildItem $location

<#
Checks if a string matches a date in MMDDYYYY format    
#>
function isDate {
    param( [String]$date )

    if ( $date -match "^\d+$" -and $date.Length -eq 8 ) {
        
        $month = [int]$date.Substring( 0, 2 )
        $day = [int]$date.Substring( 2, 2 )
        $year = [int]$date.Substring( 4 )

        if ( $month -le 12 -and $month -ge 1 -and $day -le 31 -and $day -ge 1 -and $year -ge 2014 -and $year -le 2099 ) {
            return $True
        }
    }
}

<#
Retrieves the date from a string
Precondition: String is a date
#>
function getYear {
    param( [String]$date )

    return $date.Substring( 4 )
}

<#
Main function that sorts a file containing a date into 
directories for different years
#>
function main {
    
    foreach ( $file in $files ) {
        
        $fileNameParts = $file.Basename.Split()
        foreach( $part in $fileNameParts ) {
        
            if ( isDate( $part ) ) {
                $year = getYear( $part )
                $destination = ".\" + $year

                if ( !( Test-Path $destination ) ) {
                    mkdir $year
                }

                $file | Move-Item -Destination $destination
                Break
            }
        }
    }
}

main
