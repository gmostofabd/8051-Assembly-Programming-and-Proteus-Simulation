org 0H
 
	stepper equ P3
 
main:
	mov stepper, #0CH
	acall delay
	mov stepper, #06H
	acall delay
	mov stepper, #03H
	acall delay
	mov stepper, #09H
	acall delay
	sjmp main
 
delay:
	mov r7,#4
wait2:
	mov r6,#0FFH
wait1:
	mov r5,#0FFH
wait:
	djnz r5,wait
	djnz r6,wait1
	djnz r7,wait2
	ret
	end