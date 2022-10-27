##################################################################################################
#
# script to execute the application and save the output
# params:
#  - numRuns:    number of runs to execute, performance metrics will be an average of the runs
#  - outputFile: ouput file to save output - default is arrays-perf.txt
#
#  Usage:
#  run.ps1 -numRuns 10 -outputFile out.txt
# 
##################################################################################################


# parameters
param
(
    [int]$numRuns = 5,
    [string]$outputFile = "arrays_performance.csv"
)

# rebuild the app, in case...
cmd /c dotnet build

echo "NumRuns: $numRuns"
echo "running app run $count"

[int]$count = 0;

# loop and run the app 
For ($i=1; $i -le $numRuns; $i++) {
    $count = $i;
    echo "run $count"
    cmd /c dotnet run ? >> $outputFile

   }
