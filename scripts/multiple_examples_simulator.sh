#!/bin/bash
#This script runs "example_simulator.sh" for the examples in the interval "firstExample to lastExample".
#Then it checks if all the simulation results are correct

firstExample=3
lastExample=32
waitingTime=10 #time to wait for the simulations to terminate, in seconds
errors=0 #indicates if there have been errors

echo "Starting the simulations from example $firstExample to $lastExample"
for exampleNum in $(seq $firstExample $lastExample) ; do
	eval "./example_simulator.sh $exampleNum"
	sleep $waitingTime
	curResultsFileName="../tb/results/results_ex$exampleNum.txt"
	lastLine=$(tail -n 1 $curResultsFileName)
	if [[ $lastLine == "SIMULATION ENDED SUCCESSFULLY" ]] ; then
		echo "Simulation for example $exampleNum terminated successfully."
	else
		echo "Simulation for example $exampleNum terminated with ERRORS."
		errors=1
	fi
done
if [[ $errors -eq 0 ]] ; then
	echo "All the simulations completed successfully."
else
	echo "Some simulations terminated with ERRORS."
fi


